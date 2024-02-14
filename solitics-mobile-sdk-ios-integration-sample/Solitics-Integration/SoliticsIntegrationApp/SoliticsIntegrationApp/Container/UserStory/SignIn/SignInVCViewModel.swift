//
//  SignInVCViewModel.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//
import Foundation
import SoliticsSDK
import UserNotifications
///
///
///
typealias SignInUserInput = (
    email             : String?,
    keyType             : String?,
    keyValue         : String?,
    popupToken         : String?,
    memberId         : String?,
    brand             : String?,
    branch             : String?,
    transactionAmount: String?,
    customFields     : String?
)
struct LoginRequest : ILoginMetadata
{
    public var brand        : String?
    public var branch       : String?
    
    public var email        : String?
    public var customFields : String?
    
    public var keyType      : String?
    public var keyValue        : String?
    
    public var transactionID    : String?
    public var transactionType  : String?
    public var transactionAmount: Double?
    
    public var memberId         : String?
    public var token            : String?
}

protocol SignInVCViewModelDelegate : AnyObject
{
    func onSignInSuccess()
    func onSignInError(_ error: Error)
    func didReceiveRequestPushNotificationResponse(granted: Bool)
}

final class SignInVCViewModel : NSObject
{
    weak var delegate : SignInVCViewModelDelegate?
    
    // MARK: - Life cycle
    override init()
    {
        super.init()
    }
    
    func sendSignInRequest(for userInput: SignInUserInput)
    {
        let transactionAmount: Double?  = Double(userInput.transactionAmount ?? String())
        
        let login = LoginRequest(
            brand            : userInput.brand,
            branch           : userInput.branch,
            email            : userInput.email,
            customFields     : userInput.customFields,
            keyType          : userInput.keyType,
            keyValue         : userInput.keyValue,
            transactionAmount: transactionAmount,
            memberId         : userInput.memberId,
            token            : userInput.popupToken
        )

        Solitics.onLogin(login) { [weak self] result in

            guard let strongSelf = self else { return }

            switch result
            {
            case .success           :
                strongSelf.delegate?.onSignInSuccess()
            case .failure(let error):
                strongSelf.delegate?.onSignInError(error)
            }
        }
    }
    
    // MARK: - Push Notification Registration
    func requestPushNotifications()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [unowned self] (granted, error) in
            if let error {
                print("Notification request failed with \(error.localizedDescription)")
            } else {
                print("Notification permissions \(granted ? "granted" : "denied")")
            }
            self.delegate?.didReceiveRequestPushNotificationResponse(granted: granted)
        }
    }
}
