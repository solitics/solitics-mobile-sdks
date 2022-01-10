//
//  SignInVCViewModel.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//
import Foundation
import SoliticsSDK
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
    
    public var memberId         : Int?
    public var token            : String?
}

protocol SignInVCViewModelDelegate : AnyObject
{
    func onSignInSuccess()
    func onSignInError(_ error: Error)
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
        let memberId         : Int?     = Int   (userInput.memberId          ?? String())
        let transactionAmount: Double?  = Double(userInput.transactionAmount ?? String())
        
        let login = LoginRequest(
            brand            : userInput.brand,
            branch           : userInput.branch,
            email            : userInput.email,
            customFields     : userInput.customFields,
            keyType          : userInput.keyType,
            keyValue         : userInput.keyValue,
            transactionAmount: transactionAmount,
            memberId         : memberId,
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
}
