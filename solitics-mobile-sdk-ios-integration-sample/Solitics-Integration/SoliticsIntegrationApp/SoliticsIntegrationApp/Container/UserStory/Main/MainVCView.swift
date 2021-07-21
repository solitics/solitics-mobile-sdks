//
//  MainVCView.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 04.11.2020.
//

import UIKit

protocol MainVCViewDelegate: AnyObject
{
    func didTapSendEventButton()
    func didTapLogOutButton()
}

final class MainVCView: UIView
{
    private let   containerView: UIStackView = UIStackView()
    
    private let     txTypeField: BorderedTopHintTextField = BorderedTopHintTextField()
    private let   txAmountField: BorderedTopHintTextField = BorderedTopHintTextField()
    private let customJSONField: BorderedTopHintTextField = BorderedTopHintTextField()
    
    private lazy var     fields: [BorderedTopHintTextField] = []
    
    private let sendEventButton: BlackBorderActionButton = BlackBorderActionButton()
    private let ___logOutButton: BlackBorderActionButton = BlackBorderActionButton()
    
    weak var delegate: MainVCViewDelegate?
    
    // MARK: - Life cycle
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public functions
    func getFirstResponser() -> UIView?
    {
        for field in fields where field.isFirstResponder {
            return field
        }
        return nil
    }
    
    func getUserInput() -> OnEmitEventUserInput
    {
        let txType  : String? = txTypeField.getText()
        let txAmount: Double? = Double(txAmountField.getText() ?? "") ?? nil
        let customFields: String? = customJSONField.getText()
        return OnEmitEventUserInput(txType: txType, txAmount: txAmount, customFields: customFields)
    }
    
    // MARK: - Private functions
    private func setup()
    {
        setupLayout()
        
        fields.append(contentsOf: [txTypeField, txAmountField, customJSONField])
        for (index, field) in fields.enumerated() {
            field.tag = index
        }
        sendEventButton.addTarget(self, action: #selector(MainVCView.didTapSendEventButton), for: .touchUpInside)
        ___logOutButton.addTarget(self, action: #selector(MainVCView.didTapLogOutButton   ), for: .touchUpInside)
    }
    
    private func setupLayout()
    {
        backgroundColor = .white
        
        addSubview(containerView)
        containerView.axis = .vertical
        containerView.spacing = 16.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerViewTopConstrains: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            containerViewTopConstrains = containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16)
        } else {
            containerViewTopConstrains = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        }
        
        let containerViewBottomConstrains: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            containerViewBottomConstrains = containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            containerViewBottomConstrains = containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -16)
        }
        let containerViewConstraints: [NSLayoutConstraint] = [
            containerViewTopConstrains, containerViewBottomConstrains,
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
        
        containerView.addArrangedSubview(txTypeField)
        txTypeField.update(topHint: "transactionType", placeholder: "transactionType", text: "transactionType")
        txTypeField.setKeyboardType(.asciiCapable)
        txTypeField.translatesAutoresizingMaskIntoConstraints = false
        let txTypeFieldConstraints: [NSLayoutConstraint] = [
            txTypeField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            txTypeField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(txTypeFieldConstraints)
        
        containerView.addArrangedSubview(txAmountField)
        txAmountField.update(topHint: "transactionAmount", placeholder: "transactionAmount", text: "10")
        txAmountField.setKeyboardType(.decimalPad)
        txAmountField.translatesAutoresizingMaskIntoConstraints = false
        let txAmountFieldConstraints: [NSLayoutConstraint] = [
            txAmountField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            txAmountField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(txAmountFieldConstraints)
        
        containerView.addArrangedSubview(customJSONField)
        customJSONField.update(topHint: "customJSON", placeholder: "customJSON", text: "{\"fieldName\": \"fieldValue\"}")
        customJSONField.setKeyboardType(.asciiCapable)
        customJSONField.translatesAutoresizingMaskIntoConstraints = false
        let customJSONFieldConstraints: [NSLayoutConstraint] = [
            customJSONField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            customJSONField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(customJSONFieldConstraints)
        
        containerView.addArrangedSubview(sendEventButton)
        sendEventButton.translatesAutoresizingMaskIntoConstraints = false
        sendEventButton.update(title: "SEND EVENT")
        let sendEventButtonConstraints: [NSLayoutConstraint] = [
            sendEventButton.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(sendEventButtonConstraints)
        
        containerView.addArrangedSubview(___logOutButton)
        ___logOutButton.translatesAutoresizingMaskIntoConstraints = false
        ___logOutButton.update(title: "LOG OUT")
        let logOutButtonConstraints: [NSLayoutConstraint] = [
            ___logOutButton.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(logOutButtonConstraints)
        
    }
    
    // MARK; - Actions
    @objc
    private func didTapSendEventButton()
    {
        delegate?.didTapSendEventButton()
    }
    
    @objc
    private func didTapLogOutButton()
    {
        delegate?.didTapLogOutButton()
    }
}
