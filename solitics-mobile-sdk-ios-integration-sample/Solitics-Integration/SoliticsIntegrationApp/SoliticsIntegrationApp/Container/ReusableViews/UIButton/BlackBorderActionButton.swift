//
//  BlackBorderActionButton.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 23.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//

import UIKit

final class BlackBorderActionButton: UIButton
{
    private lazy var borderColorActive  : UIColor = .black
    private lazy var borderColorInactive: UIColor = UIColor.gray
    
    private lazy var titleLabelFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    
    // MARK: - Life cycle
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Public methods
    func update(isEnabled: Bool, title: String?)
    {
        setTitle(title, for: .normal)
        self.isEnabled = isEnabled
        updateBorderColor(isEnabled)
    }
    
    func update(title: String?)
    {
        setTitle(title, for: .normal)
    }
    
    func updateBackgroundColor(_ color: UIColor)
    {
        backgroundColor = color
    }
    
    func changeTitleFont(_ font: UIFont)
    {
        titleLabel?.font = font
    }
    
    func updateBorderColor(_ isEnabled: Bool)
    {
        
        let color: UIColor = isEnabled ? borderColorActive : borderColorInactive
        layer.borderColor = color.cgColor
    }
    
    // MARK: - Private methods
    private func setupLayout()
    {
        layer.cornerRadius = 8.0
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.font = titleLabelFont
        setTitleColor(.black, for: .normal)
        setTitleColor(borderColorInactive, for: .disabled)
        
        adjustsImageWhenHighlighted = false
        contentHorizontalAlignment = .center
    }
}
