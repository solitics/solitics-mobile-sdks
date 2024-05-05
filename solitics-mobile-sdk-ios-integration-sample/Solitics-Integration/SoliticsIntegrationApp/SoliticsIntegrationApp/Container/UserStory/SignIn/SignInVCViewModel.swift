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
    email       : String?,
    keyType     : String?,
    keyValue    : String?,
    popupToken  : String?,
    memberId    : String?,
    brand       : String?,
    branch      : String?,
    amount      : String?,
    customFields: String?
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
    class Keys
    {
        static var      email : String { "_keyEmail" }
        static var    keyType : String { "_keyKeyType" }
        static var   keyValue : String { "_keyKeyValue" }
        static var popupToken : String { "_keyToken" }
        static var   memberId : String { "_keyMemberId" }
        static var      brand : String { "_keyBrand" }
        static var     branch : String { "_keyBranch" }
        static var     amount : String { "_keyAmount" }
        static var customJSON : String { "_keyCustomJSON" }
    }
    class Defaults
    {
        static var      email : String = "iphone01@test.com"
        static var    keyType : String = String()
        static var   keyValue : String = String()
        static var popupToken : String = "78feae7a-4e5b-440f-aa08-cb3e55523f5b"
        static var   memberId : String = "iphone01"
        static var      brand : String = "78feae7a-4e5b-440f-aa08-cb3e55523f5b"
        static var     branch : String = String()
        static var     amount : String = "0"
        static var customJSON : String = "{\"fieldName\": \"fieldValue\"}"
    }
    
    static func saveCurrentUser(user: SignInUserInput) {
        
        let defaults = UserDefaults.standard
        defaults.setValue(user.email       , forKey: Keys.email)
        defaults.setValue(user.keyType     , forKey: Keys.keyType)
        defaults.setValue(user.keyValue    , forKey: Keys.keyValue)
        defaults.setValue(user.popupToken  , forKey: Keys.popupToken)
        defaults.setValue(user.memberId    , forKey: Keys.memberId)
        defaults.setValue(user.brand       , forKey: Keys.brand)
        defaults.setValue(user.branch      , forKey: Keys.branch)
        defaults.setValue(user.amount      , forKey: Keys.amount)
        defaults.setValue(user.customFields, forKey: Keys.customJSON)
        defaults.synchronize()
    }
    static func currentDiskUser() -> SignInUserInput {
        
        let defaults = UserDefaults.standard

        return SignInUserInput(
            email       : defaults.string(forKey: Keys.email     ) ?? Defaults.email,
            keyType     : defaults.string(forKey: Keys.keyType   ) ?? Defaults.keyType,
            keyValue    : defaults.string(forKey: Keys.keyValue  ) ?? Defaults.keyValue,
            popupToken  : defaults.string(forKey: Keys.popupToken) ?? Defaults.popupToken,
            memberId    : defaults.string(forKey: Keys.memberId  ) ?? Defaults.memberId,
            brand       : defaults.string(forKey: Keys.brand     ) ?? Defaults.brand,
            branch      : defaults.string(forKey: Keys.branch    ) ?? Defaults.branch,
            amount      : defaults.string(forKey: Keys.amount    ) ?? Defaults.amount,
            customFields: defaults.string(forKey: Keys.customJSON) ?? Defaults.customJSON
        )
    }
    weak var delegate : SignInVCViewModelDelegate?
    
    // MARK: - Life cycle
    override init()
    {
        super.init()
    }
    
    func sendSignInRequest(for userInput: SignInUserInput)
    {
        let transactionAmount: Double?  = Double(userInput.amount ?? String())
        
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge , .providesAppNotificationSettings]) { [unowned self] (granted, error) in
            if let error {
                print("Notification request failed with \(error.localizedDescription)")
            } else {
                print("Notification permissions \(granted ? "granted" : "denied")")
            }
            self.delegate?.didReceiveRequestPushNotificationResponse(granted: granted)
        }
    }
}
