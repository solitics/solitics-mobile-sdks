//
//  BorderedTopHintTextField.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 25.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
final class BorderedTopHintTextField: UIView
{
    lazy var textField: InsetsTextField = InsetsTextField()
    
    private lazy var borderWidth: CGFloat = 1.0
    private lazy var textFieldHeight: CGFloat = 40.0
    private lazy var textFieldOffset: CGFloat = 8.0
    private lazy var textFieldInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    
    private lazy var placeholdelLabelUnderlay: UIView = UIView()
    
    private lazy var placeholderLabel: UILabel = UILabel()
    private lazy var placeholderLabelInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    private lazy var placeholderLabelFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    private lazy var bottomLabelContainer: UIStackView = UIStackView()
    private lazy var bottomLabelContainerSpacing: CGFloat = 4.0
    
    private lazy var bottomHintLabel: UILabel = UILabel()
    private lazy var bottomHintLabelFont: UIFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    private lazy var bottomHintLabelColor: UIColor = UIColor.black.withAlphaComponent(0.54)
    
    private lazy var showHidePasswordButton: UIButton = UIButton()
    private lazy var showHidePasswordButtonSize: CGFloat = 55.0 / 2
    private lazy var showHidePasswordButtonOffset: CGFloat = 16.0 * 2
    
    private lazy var showPasswordImage: UIImage? = UIImage()
    private lazy var hidePasswordImage: UIImage? = UIImage()
    
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
    func updateBottomHintText(_ text: String?)
    {
        bottomHintLabel.isHidden = text == nil
        bottomHintLabel.text = text
    }
    
    func update(topHint: String?, placeholder: String?, text: String?)
    {
        placeholderLabel.text = topHint
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black.withAlphaComponent(0.38),
                                                         .font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        textField.text = text
    }
    
    func setAutocapitalizationType(_ type: UITextAutocapitalizationType)
    {
        textField.autocapitalizationType = type
    }
    
    func setKeyboardType(_ type: UIKeyboardType)
    {
        textField.keyboardType = type
    }
    
    func setValue(text: String?)
    {
        textField.text = text
    }
    
    func getText() -> String?
    {
        if textField.text?.isEmpty ?? true
        {
            return nil
        }
        else
        {
            return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func changeTextVisibility(isSecure: Bool)
    {
        textField.isSecureTextEntry = isSecure
    }
    
    func changeRightButtonVisibility(isVisible: Bool)
    {
        guard isVisible else {
            showHidePasswordButton.removeFromSuperview()
            textField.rightView = nil
            textField.rightViewMode = .never
            return
        }
        textField.addSubview(showHidePasswordButton)
        showHidePasswordButton.backgroundColor = textField.backgroundColor
        
        switch textField.isSecureTextEntry {
        case true : showHidePasswordButton.setImage(hidePasswordImage, for: .normal)
        case false: showHidePasswordButton.setImage(showPasswordImage, for: .normal)
        }
        let selector = #selector(BorderedTopHintTextField.didTapChangePasswordVisibilityBtn)
        showHidePasswordButton.addTarget(self, action: selector, for: .touchUpInside)
        textField.rightView = showHidePasswordButton
        textField.rightViewMode = .always
    }
    
    // MARK: - Private functions
    private func setup()
    {
        setupLayout()
        setupGestures()
    }
    
    private func setupGestures()
    {
        let selector = #selector(BorderedTopHintTextField.didTapTopHintLabel)
        let topPlaceholderUnderlayTap = UITapGestureRecognizer(target: self, action: selector)
        placeholdelLabelUnderlay.addGestureRecognizer(topPlaceholderUnderlayTap)
        
        let topPlaceholderLabelTap    = UITapGestureRecognizer(target: self, action: selector)
        placeholderLabel.addGestureRecognizer(topPlaceholderLabelTap)
    }
    
    private func setupLayout()
    {
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
        addSubview(placeholdelLabelUnderlay)
        placeholdelLabelUnderlay.isUserInteractionEnabled = true
        placeholdelLabelUnderlay.layer.zPosition = 1000
        placeholdelLabelUnderlay.backgroundColor = .white
        
        placeholdelLabelUnderlay.translatesAutoresizingMaskIntoConstraints = false
        let placeholdelLabelUnderlayConstraints: [NSLayoutConstraint] = [placeholdelLabelUnderlay.topAnchor.constraint(equalTo: self.topAnchor),
                                                                         placeholdelLabelUnderlay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)]
        NSLayoutConstraint.activate(placeholdelLabelUnderlayConstraints)
        
        placeholdelLabelUnderlay.addSubview(placeholderLabel)
        placeholderLabel.isUserInteractionEnabled = true
        placeholderLabel.backgroundColor = .white
        placeholderLabel.textColor = UIColor.black.withAlphaComponent(0.54)
        placeholderLabel.font = placeholderLabelFont
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let placeholdelLabelConstraints: [NSLayoutConstraint] = [
            placeholderLabel.topAnchor      .constraint(equalTo: placeholdelLabelUnderlay.topAnchor     , constant:  placeholderLabelInset.top),
            placeholderLabel.bottomAnchor   .constraint(equalTo: placeholdelLabelUnderlay.bottomAnchor  , constant: -placeholderLabelInset.bottom),
            placeholderLabel.leadingAnchor  .constraint(equalTo: placeholdelLabelUnderlay.leadingAnchor , constant:  placeholderLabelInset.left),
            placeholderLabel.trailingAnchor .constraint(equalTo: placeholdelLabelUnderlay.trailingAnchor, constant: -placeholderLabelInset.right)
        ]
        NSLayoutConstraint.activate(placeholdelLabelConstraints)
        
        addSubview(textField)
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let textFieldConstraints: [NSLayoutConstraint] = [
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: textFieldOffset),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textFieldInsets.left),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textFieldInsets.right),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
        
        addSubview(bottomLabelContainer)
        bottomLabelContainer.axis = .vertical
        bottomLabelContainer.spacing = bottomLabelContainerSpacing
        
        bottomLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLabelContainerConstraints: [NSLayoutConstraint] = [
            bottomLabelContainer.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: bottomLabelContainerSpacing),
            bottomLabelContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: placeholderLabelInset.left),
            bottomLabelContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -placeholderLabelInset.right),
            bottomLabelContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(bottomLabelContainerConstraints)
        
        bottomLabelContainer.addArrangedSubview(bottomHintLabel)
        bottomHintLabel.adjustsFontSizeToFitWidth = true
        bottomHintLabel.minimumScaleFactor = 0.5
        bottomHintLabel.isHidden = true
        bottomHintLabel.font = bottomHintLabelFont
        bottomHintLabel.textColor = bottomHintLabelColor
    }
    
    // MARK: - Actions
    @objc
    private func didTapChangePasswordVisibilityBtn()
    {
        switch textField.isSecureTextEntry
        {
        case true : showHidePasswordButton.setImage(hidePasswordImage, for: .normal)
        case false: showHidePasswordButton.setImage(showPasswordImage, for: .normal)
        }
        textField.isSecureTextEntry.toggle()
    }
    
    @objc
    private func didTapTopHintLabel()
    {    
        textField.becomeFirstResponder()
    }
    
}
