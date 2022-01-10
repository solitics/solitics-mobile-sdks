//
//  InsetsTextField.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 20.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
final class InsetsTextField: UITextField
{
    private lazy var insetX : CGFloat = 10.0
    private lazy var insetY : CGFloat =  0.0
    
    private lazy var rightViewSize : CGFloat = 55.0 / 2
    
    func changeInsets(x: CGFloat, y: CGFloat)
    {
        insetX = x
        insetY = y
    }
    
    func changeRightViewSize(size: CGFloat)
    {
        rightViewSize = size
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        let paddedRect = bounds.insetBy(dx: insetX, dy: insetY)
        
        if rightViewMode == UITextField.ViewMode.always || rightViewMode == UITextField.ViewMode.unlessEditing
        {
            return adjustRectForRightView(rect: paddedRect)
        }
        
        return paddedRect
    }
    
    // placeholder position
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        let paddedRect = bounds.insetBy(dx: insetX, dy: insetY)
        
        if rightViewMode == UITextField.ViewMode.always || rightViewMode == UITextField.ViewMode.unlessEditing
        {
            return adjustRectForRightView(rect: paddedRect)
        }
        return paddedRect
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        let paddedRect = bounds.insetBy(dx: insetX, dy: insetY)
        if rightViewMode == UITextField.ViewMode.always || rightViewMode == UITextField.ViewMode.whileEditing
        {
            return adjustRectForRightView(rect: paddedRect)
        }
        return paddedRect
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        // if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        //     return false
        // }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect
    {
        let origin : CGPoint = CGPoint(x: bounds.maxX - rightViewSize * 1.5,
                                       y: bounds.midY - rightViewSize / 2.0)
        let size   : CGSize  = CGSize(width: rightViewSize, height: rightViewSize)
        return CGRect(origin: origin, size: size)
    }
    
    // MARK: - Private functions
    private func adjustRectForRightView(rect: CGRect) -> CGRect
    {
        var paddedRect: CGRect = rect
        paddedRect.size.width -= (self.rightView?.frame ?? CGRect.zero).width
        return paddedRect
    }
}
