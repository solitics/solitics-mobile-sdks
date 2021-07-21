//
//  SignInVCView.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 04.11.2020.
//

import UIKit

protocol SignInVCViewDelegate : AnyObject
{
    func didTapSignInButton()
}

final class SignInVCView : UIView
{
    private let containerView : UIStackView = UIStackView()
    
    private let emailField            : BorderedTopHintTextField = BorderedTopHintTextField()
    private let keyTypeField          : BorderedTopHintTextField = BorderedTopHintTextField()
    private let keyValueField	      : BorderedTopHintTextField = BorderedTopHintTextField()
    private let popupTokenField	      : BorderedTopHintTextField = BorderedTopHintTextField()
    private let memberIdField	      : BorderedTopHintTextField = BorderedTopHintTextField()
    private let brandField	          : BorderedTopHintTextField = BorderedTopHintTextField()
    private let branchField           : BorderedTopHintTextField = BorderedTopHintTextField()
    private let transactionAmountField: BorderedTopHintTextField = BorderedTopHintTextField()
    private let customJSONField       : BorderedTopHintTextField = BorderedTopHintTextField()
    
    private lazy var fields : [BorderedTopHintTextField] = []
    private let signInButton: BlackBorderActionButton = BlackBorderActionButton()
    
    weak var delegate: SignInVCViewDelegate?
    
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
        for field in fields where field.isFirstResponder
        {
            return field
        }
        return nil
    }
    
    func getUserInput() -> SignInUserInput
    {    
        return SignInUserInput(
            email            : emailField.getText(),
            keyType          : keyTypeField.getText(),
            keyValue	     : keyValueField.getText(),
            popupToken       : popupTokenField.getText(),
            memberId	     : memberIdField.getText(),
            brand            : brandField.getText(),
            branch           : branchField.getText(),
            transactionAmount: transactionAmountField.getText(),
            customFields     : customJSONField.getText()
        )
    }
    
    // MARK: - Private functions
    private func setup()
    {
        setupLayout()
        let local = [emailField, keyTypeField, keyValueField, popupTokenField, brandField, transactionAmountField, customJSONField]
        fields.append(contentsOf: local)
        
        for (index, field) in fields.enumerated() {
            field.tag = index
        }
        
        let selector = #selector(SignInVCView.didTapSignInButton)
        signInButton.addTarget(self, action: selector, for: .touchUpInside)
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
            containerViewBottomConstrains = containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            containerViewBottomConstrains = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        }
        let containerViewConstraints: [NSLayoutConstraint] = [
            containerViewTopConstrains, containerViewBottomConstrains,
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
        
        containerView.addArrangedSubview(emailField)
        emailField.update(topHint: "email", placeholder: "email", text: "demo@solitics.com")
        emailField.setKeyboardType(.emailAddress)
        let emailFieldConstraints: [NSLayoutConstraint] = [
            emailField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(emailFieldConstraints)
        
        containerView.addArrangedSubview(keyTypeField)
        keyTypeField.update(topHint: "keyTypeField", placeholder: "keyTypeField", text: "crm")
        keyTypeField.setKeyboardType(.asciiCapable)
        let keyTypeFieldConstraints: [NSLayoutConstraint] = [
            keyTypeField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            keyTypeField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(keyTypeFieldConstraints)
        
        containerView.addArrangedSubview(keyValueField)
        keyValueField.update(topHint: "keyValueField", placeholder: "keyValueField", text: "54321098")
        keyValueField.setKeyboardType(.asciiCapable)
        let keyValueFieldConstraints: [NSLayoutConstraint] = [
            keyValueField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            keyValueField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(keyValueFieldConstraints)
        
        containerView.addArrangedSubview(popupTokenField)
        popupTokenField.update(topHint: "popupTokenField", placeholder: "popupTokenField", text: "Wf9fsDARzdtCqDFJ9cVKrmuF")
        popupTokenField.setKeyboardType(.asciiCapable)
        let popupTokenFieldConstraints: [NSLayoutConstraint] = [
            popupTokenField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            popupTokenField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(popupTokenFieldConstraints)
        
        containerView.addArrangedSubview(memberIdField)
        memberIdField.update(topHint: "memberIdField", placeholder: "memberIdField", text: "9910410111064")
        memberIdField.setKeyboardType(.asciiCapable)
        let memberIdFieldConstraints: [NSLayoutConstraint] = [
            memberIdField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            memberIdField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(memberIdFieldConstraints)
        
        containerView.addArrangedSubview(brandField)
        brandField.update(topHint: "brandField", placeholder: "brandField", text: "Fashion")
        brandField.setKeyboardType(.asciiCapable)
        let brandFieldConstraints: [NSLayoutConstraint] = [
            brandField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            brandField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(brandFieldConstraints)
        
        containerView.addArrangedSubview(branchField)
        branchField.update(topHint: "branchField", placeholder: "branchField", text: nil)
        branchField.setKeyboardType(.asciiCapable)
        let branchFieldConstraints: [NSLayoutConstraint] = [
            branchField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            branchField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(branchFieldConstraints)
        
        containerView.addArrangedSubview(transactionAmountField)
        transactionAmountField.update(topHint: "transactionAmountField", placeholder: "transactionAmountField", text: "0")
        transactionAmountField.setKeyboardType(.asciiCapable)
        let transactionAmountFieldConstraints: [NSLayoutConstraint] = [
            transactionAmountField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            transactionAmountField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(transactionAmountFieldConstraints)
        
        containerView.addArrangedSubview(customJSONField)
        customJSONField.update(topHint: "customJSON", placeholder: "customJSON", text: "{\"fieldName\": \"fieldValue\"}")
        customJSONField.setKeyboardType(.asciiCapable)
        customJSONField.translatesAutoresizingMaskIntoConstraints = false
        let customJSONFieldConstraints: [NSLayoutConstraint] = [
            customJSONField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            customJSONField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(customJSONFieldConstraints)
        
        containerView.addArrangedSubview(signInButton)
        signInButton.update(title: "LOGIN")
        let signInButtonConstraints: [NSLayoutConstraint] = [
            signInButton.widthAnchor.constraint(equalTo: signInButton.widthAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 40.0)
        ]
        NSLayoutConstraint.activate(signInButtonConstraints)
    }
    
    // MARK: - Actions
    @objc
    private func didTapSignInButton()
    {
        delegate?.didTapSignInButton()
    }
}
