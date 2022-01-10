//
//  MainVCViewModel.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//
import Foundation
import SoliticsSDK
///
///
///
typealias OnEmitEventUserInput = (
    txType      : String?,
    txAmount    : Double?,
    customFields: String?
)

protocol MainVCViewModelDelegate: AnyObject
{
    func didReceiveError(_ error: Error)
    func didReceiveEventResponse(response: String)
}

final class MainVCViewModel: NSObject , UniqueIdentifiable
{
    var identifier    : UUID
    weak var delegate : MainVCViewModelDelegate?
    
    // MARK: - Life cycle
    override init()
    {
        self.identifier = UUID()
        super.init()
    }
    
    deinit
    {
        
    }
    
    // MARK: - Sign out
    func signOut()
    {
        Solitics.onLogout()
    }
    
    // MARK: - Web-socket connection
    func setupSocketConnection()
    {
        // sdkInstance.setupSocketConnection()
    }
    
    // MARK: - Event sending to REST API
    func sendEventRequest(inputData: OnEmitEventUserInput)
    {
        Solitics.onEmitEvent(
            txType        : inputData.txType,
            txAmount    : inputData.txAmount,
            customFields: inputData.customFields) { [weak self] result in
            
            guard let strongSelf = self else { return }
            switch result
            {
            case .success(let loginResult):
                let hashedId       = loginResult.hashedSubscriberId
                let transaction    = SOLEmitEventResult.init(hashedId)
                let responseString = transaction.toJSON().jsonString ?? String()
                strongSelf.delegate?.didReceiveEventResponse(response: responseString)
                break
            case .failure(let error):
                strongSelf.delegate?.didReceiveError(error)
            break
            }
        }
    }
}
