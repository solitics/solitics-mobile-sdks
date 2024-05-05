//
//  SignInVCView.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 04.11.2020.
//
import UIKit
///
///
///
protocol SignInVCViewDelegate : AnyObject
{
    func didTapSignInButton()
    func didTapRequestPushPermission()
}
///
///
///
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
    private let    clearButton: BlackBorderActionButton = BlackBorderActionButton()
    private let saveUserButton: BlackBorderActionButton = BlackBorderActionButton()
    private let loadUserButton: BlackBorderActionButton = BlackBorderActionButton()
    private let defaultsButton: BlackBorderActionButton = BlackBorderActionButton()
    private let loginSoliticsButton: BlackBorderActionButton = BlackBorderActionButton()
    private let   requestPushButton: BlackBorderActionButton = BlackBorderActionButton()
    
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
            email       : emailField.getText() ?? String(),
            keyType     : keyTypeField.getText() ?? String(),
            keyValue	: keyValueField.getText() ?? String(),
            popupToken  : popupTokenField.getText() ?? String(),
            memberId	: memberIdField.getText() ?? String(),
            brand       : brandField.getText() ?? String(),
            branch      : branchField.getText() ?? String(),
            amount      : transactionAmountField.getText() ?? String(),
            customFields: customJSONField.getText() ?? String()
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
        
        clearButton.addTarget(self, action: #selector(SignInVCView.didTapClearButton), for: .touchUpInside)
        saveUserButton.addTarget(self, action: #selector(SignInVCView.didTapSaveUserButton), for: .touchUpInside)
        loadUserButton.addTarget(self, action: #selector(SignInVCView.didTapLoadUserButton), for: .touchUpInside)
        defaultsButton.addTarget(self, action: #selector(SignInVCView.didTapDefaultsButton), for: .touchUpInside)
        
        let selector = #selector(SignInVCView.didTapSignInButton)
        loginSoliticsButton.addTarget(self, action: selector, for: .touchUpInside)
        
        let pushPermissionSelector = #selector(SignInVCView.didTapRequestPushPermission)
        requestPushButton.addTarget(self, action: pushPermissionSelector, for: .touchUpInside)
    }
    
    private func setupLayout()
    {
        backgroundColor = .white
        
        addSubview(containerView)
        containerView.axis    = .vertical
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
        
        let current = SignInVCViewModel.currentDiskUser()
        
        containerView.addArrangedSubview(emailField)
        emailField.update(topHint: "email", placeholder: "email", text: current.email)
        emailField.setKeyboardType(.emailAddress)
        let emailFieldConstraints: [NSLayoutConstraint] = [
            emailField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(emailFieldConstraints)
        
        containerView.addArrangedSubview(keyTypeField)
        keyTypeField.update(topHint: "keyTypeField", placeholder: "keyTypeField", text: current.keyType)
        keyTypeField.setKeyboardType(.asciiCapable)
        let keyTypeFieldConstraints: [NSLayoutConstraint] = [
            keyTypeField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            keyTypeField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(keyTypeFieldConstraints)
        
        containerView.addArrangedSubview(keyValueField)
        keyValueField.update(topHint: "keyValueField", placeholder: "keyValueField", text: current.keyValue)
        keyValueField.setKeyboardType(.asciiCapable)
        let keyValueFieldConstraints: [NSLayoutConstraint] = [
            keyValueField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            keyValueField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(keyValueFieldConstraints)
        
        containerView.addArrangedSubview(popupTokenField)
        popupTokenField.update(topHint: "popupTokenField", placeholder: "popupTokenField", text: current.popupToken)
        popupTokenField.setKeyboardType(.asciiCapable)
        let popupTokenFieldConstraints: [NSLayoutConstraint] = [
            popupTokenField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            popupTokenField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(popupTokenFieldConstraints)
        
        containerView.addArrangedSubview(memberIdField)
        memberIdField.update(topHint: "memberIdField", placeholder: "memberIdField", text: current.memberId)
        memberIdField.setKeyboardType(.asciiCapable)
        let memberIdFieldConstraints: [NSLayoutConstraint] = [
            memberIdField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            memberIdField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(memberIdFieldConstraints)
        
        containerView.addArrangedSubview(brandField)
        brandField.update(topHint: "brandField", placeholder: "brandField", text: current.brand)
        brandField.setKeyboardType(.asciiCapable)
        let brandFieldConstraints: [NSLayoutConstraint] = [
            brandField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            brandField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(brandFieldConstraints)
        
        containerView.addArrangedSubview(branchField)
        branchField.update(topHint: "branchField", placeholder: "branchField", text: current.branch)
        branchField.setKeyboardType(.asciiCapable)
        let branchFieldConstraints: [NSLayoutConstraint] = [
            branchField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            branchField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(branchFieldConstraints)
        
        containerView.addArrangedSubview(transactionAmountField)
        transactionAmountField.update(topHint: "transactionAmountField", placeholder: "transactionAmountField", text: current.amount)
        transactionAmountField.setKeyboardType(.asciiCapable)
        let transactionAmountFieldConstraints: [NSLayoutConstraint] = [
            transactionAmountField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            transactionAmountField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(transactionAmountFieldConstraints)
        
        containerView.addArrangedSubview(customJSONField)
        customJSONField.update(topHint: "customJSON", placeholder: "customJSON", text: current.customFields)
        customJSONField.setKeyboardType(.asciiCapable)
        customJSONField.translatesAutoresizingMaskIntoConstraints = false
        let customJSONFieldConstraints: [NSLayoutConstraint] = [
            customJSONField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            customJSONField.heightAnchor.constraint(equalToConstant: 60.0)
        ]
        NSLayoutConstraint.activate(customJSONFieldConstraints)
        
        let topUserContainerView = UIStackView()
        topUserContainerView.axis = .horizontal
        topUserContainerView.alignment = .center
        topUserContainerView.distribution = .fillEqually
        topUserContainerView.spacing = 10.0
        topUserContainerView.addArrangedSubview(saveUserButton)
        topUserContainerView.addArrangedSubview(clearButton)
        
        let buttomUserContainerView = UIStackView()
        buttomUserContainerView.axis = .horizontal
        buttomUserContainerView.alignment = .center
        buttomUserContainerView.distribution = .fillEqually
        buttomUserContainerView.spacing = 10.0
        buttomUserContainerView.addArrangedSubview(loadUserButton)
        buttomUserContainerView.addArrangedSubview(defaultsButton)
        
        saveUserButton.update(title: "Save")
        loadUserButton.update(title: "Load")
        clearButton.update(title: "Clear")
        defaultsButton.update(title: "Defaults")
        NSLayoutConstraint.activate([
            saveUserButton.heightAnchor.constraint(equalToConstant: 40.0),
            loadUserButton.heightAnchor.constraint(equalToConstant: 40.0),
            clearButton.heightAnchor.constraint(equalToConstant: 40.0),
            defaultsButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        
        containerView.addArrangedSubview(topUserContainerView)
        containerView.addArrangedSubview(buttomUserContainerView)
        
        containerView.addArrangedSubview(loginSoliticsButton)
        loginSoliticsButton.update(title: "LOGIN")
        let signInButtonConstraints: [NSLayoutConstraint] = [
            loginSoliticsButton.widthAnchor.constraint(equalTo: loginSoliticsButton.widthAnchor),
            loginSoliticsButton.heightAnchor.constraint(equalToConstant: 40.0)
        ]
        NSLayoutConstraint.activate(signInButtonConstraints)
        
        containerView.addArrangedSubview(requestPushButton)
        requestPushButton.update(title: "Request APN")
        let requestPushPermissionButtonConstraints: [NSLayoutConstraint] = [
            requestPushButton.widthAnchor.constraint(equalTo: loginSoliticsButton.widthAnchor),
            requestPushButton.heightAnchor.constraint(equalToConstant: 40.0)
        ]
        NSLayoutConstraint.activate(requestPushPermissionButtonConstraints)
    }
    
    // MARK: - Actions
    @objc
    private func didTapSaveUserButton()
    {
        SignInVCViewModel.saveCurrentUser(user: getUserInput())
    }
    @objc
    private func didTapLoadUserButton()
    {
        let current = SignInVCViewModel.currentDiskUser()
        emailField.setValue(text: current.email)
        keyTypeField.setValue(text: current.keyType)
        keyValueField.setValue(text: current.keyValue)
        popupTokenField.setValue(text: current.popupToken)
        memberIdField.setValue(text: current.memberId)
        brandField.setValue(text: current.brand)
        branchField.setValue(text: current.branch)
        transactionAmountField.setValue(text: current.amount)
        customJSONField.setValue(text: current.customFields)
    }
    
    @objc
    private func didTapClearButton()
    {
        [
            emailField,
            keyTypeField,
            keyValueField,
            popupTokenField,
            memberIdField,
            brandField,
            branchField
        ].forEach {
            $0.setValue(text: nil)
        }
        
        transactionAmountField.setValue(text: SignInVCViewModel.Defaults.amount)
        customJSONField.setValue(text: SignInVCViewModel.Defaults.customJSON)
    }
    
    @objc
    private func didTapDefaultsButton()
    {
        emailField.setValue(text: SignInVCViewModel.Defaults.email)
        keyTypeField.setValue(text: SignInVCViewModel.Defaults.keyType)
        keyValueField.setValue(text: SignInVCViewModel.Defaults.keyValue)
        popupTokenField.setValue(text: SignInVCViewModel.Defaults.popupToken)
        memberIdField.setValue(text: SignInVCViewModel.Defaults.memberId)
        brandField.setValue(text: SignInVCViewModel.Defaults.brand)
        branchField.setValue(text: SignInVCViewModel.Defaults.branch)
        transactionAmountField.setValue(text: SignInVCViewModel.Defaults.amount)
        customJSONField.setValue(text: SignInVCViewModel.Defaults.customJSON)
    }
    
    @objc
    private func didTapSignInButton()
    {
        delegate?.didTapSignInButton()
    }
    
    @objc
    private func didTapRequestPushPermission()
    {
        delegate?.didTapRequestPushPermission()
    }
}
