//
//  MainVCViewModel.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//

import Foundation
import SoliticsSDK

typealias OnEmitEventUserInput = (
    txType      : String?,
    txAmount    : Double?,
    customFields: String?
)

protocol MainVCViewModelDelegate: AnyObject
{
    func didReceiveSocketData(_ data: Data)
    func didReceiveError(_ error: Error)
    func didReceiveEventResponse(response: String)
    func didReceivePopupData(data: SocketPopupJSONMessage)
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
        Solitics.addEventsObserver(events: DataUpdateNotification.allCases, observer: self)
    }
    
    deinit
    {
        Solitics.removeObserver(observer: self, for: DataUpdateNotification.allCases)
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
            txType	    : inputData.txType,
            txAmount    : inputData.txAmount,
            customFields: inputData.customFields) { [weak self] result in
            
            guard let strongSelf = self else { return }
            switch result
            {
            case .success(let loginResult):
                let hashedId       = loginResult.hashedSubscriberId
                let transaction    = TransactionResponse(hashedSubscriberId: hashedId)
                let responseString = transaction.toJSON().jsonString ?? String()
                strongSelf.delegate?.didReceiveEventResponse(response: responseString)
                
            case .failure(let error):
                strongSelf.delegate?.didReceiveError(error)
            }
        }
    }
}

// MARK: - AppContentUpdateObserver
extension MainVCViewModel: AppContentUpdateObserver
{
    func didReceiveResponse(for event: DataUpdateNotification, data: DataUpdateInfo)
    {
        switch event
        {
        case .didReceiveSocketPopupMessage:
            
            guard let message = SocketPopupJSONMessage.fromDataUpdate(data) else {
                return
            }
            self.delegate?.didReceivePopupData(data: message)
            
        case .didReceiveSocketData:
            
            guard let message = SocketDataMessage.fromDataUpdate(data) else {
                return
            }
            self.delegate?.didReceiveSocketData(message.data)
            
        case .didReceiveSocketString:
            
            guard let message = SocketStringMessage.fromDataUpdate(data) else {
                return
            }
            if let socketData = message.message.data(using: .utf8) {
                self.delegate?.didReceiveSocketData(socketData)
            }
            
        case .didReceiveSocketError:
            
            guard let message = SocketStringMessage.fromDataUpdate(data) else {
                return
            }
            let error: Error = AppInternalError.error(errorMessage: message.message)
            self.delegate?.didReceiveError(error)
            
        @unknown default:
            fatalError()
        }
    }
}
