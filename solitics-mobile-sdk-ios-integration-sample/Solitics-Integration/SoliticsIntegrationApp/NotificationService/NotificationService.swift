//
//  NotificationService.swift
//  NotificationService
//
//  Created by Alex Pinhasov on 12/12/2023.
//

import UserNotifications
import SoliticsSDK

enum FileType: String {
    case jpg = "image/jpeg"
    case gif = "image/gif"
    case png = "image/png"
    case tmp = "image/tmp"
    
    var fileExtension: String {
        switch self {
        case .jpg: return ".jpg"
        case .gif: return ".gif"
        case .png: return ".png"
        case .tmp: return ".tmp"
        }
    }
}

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        NSLog("InternalTesting: didReceive:withContentHandler: ")

        SoliticsSDK.Solitics.didReceivePushNotificationRequest(for: request)
        
        let packageServices: [ServiceProtocol] = [FirebaseService(), OneSignalService(),SoliticsSDKService()]
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        let userInfo = request.content.userInfo;
        
        // MARK: - Rich Push
        guard let selectedService = packageServices.first(where: { $0.canHandleNotification(userInfo: userInfo) }) else { return }

        if let imageURL = selectedService.imageURL(fromUserInfo: userInfo) {
            handleDownloadImage(from: imageURL)
        }
    }
    
    private func handleDownloadImage(from url: URL) {
        guard let contentHandler, let bestAttemptContent else {
            return
        }
        
        URLSession(configuration: .default).downloadTask(with: url, completionHandler: { temporaryLocation, response, error in
            if let err = error {
                print("Solitics: Error with downloading rich push: \(String(describing: err.localizedDescription))")
                contentHandler(bestAttemptContent)
                return
            }
            
            guard let mimeType = response?.mimeType,
                  let fileExtension = FileType(rawValue: mimeType)?.fileExtension,
                  let fileName = temporaryLocation?.lastPathComponent.appending(fileExtension),
                  let temporaryLocation else {
                print("Solitics: Error with parsing attachment")
                contentHandler(bestAttemptContent)
                return
            }
            
            let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            do {
                try FileManager.default.moveItem(at: temporaryLocation, to: temporaryDirectory)
                let attachment = try UNNotificationAttachment(identifier: "", url: temporaryDirectory, options: nil)
                
                bestAttemptContent.attachments = [attachment];
                contentHandler(bestAttemptContent);
                // The file should be removed automatically from temp
                // Delete it manually if it is not
                if FileManager.default.fileExists(atPath: temporaryDirectory.path) {
                    try FileManager.default.removeItem(at: temporaryDirectory)
                }
            } catch {
                print("Solitics: Error with the rich push attachment: \(error)")
                contentHandler(bestAttemptContent)
                return
            }
        }).resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
