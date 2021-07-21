//
//  SignInVCViewModel.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//

import Foundation
import SoliticsSDK

typealias SignInUserInput = (
    email	         : String?,
    keyType	         : String?,
    keyValue	     : String?,
    popupToken	     : String?,
    memberId	     : String?,
    brand	         : String?,
    branch	         : String?,
    transactionAmount: String?,
    customFields     : String?
)

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
        
        let request : TransactionRequest = TransactionRequest(
            brand            : userInput.brand,
            branch           : userInput.branch,
            email            : userInput.email,
            customFields     : userInput.customFields,
            keyType          : userInput.keyType,
            keyValue         : userInput.keyValue,
            transactionID    : EventTransactionId.login.uuid,
            transactionType  : EventType.login.rawValue,
            transactionAmount: transactionAmount,
            memberId         : memberId,
            token            : userInput.popupToken
        )
        
        Solitics.onLogin(loginMetadata: request) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result
            {
            case .success           : strongSelf.delegate?.onSignInSuccess()
            case .failure(let error): strongSelf.delegate?.onSignInError(error)
            }
        }
    }
}
