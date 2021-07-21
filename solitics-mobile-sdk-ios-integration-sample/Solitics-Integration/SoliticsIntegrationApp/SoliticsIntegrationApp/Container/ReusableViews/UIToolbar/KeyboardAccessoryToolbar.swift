//
//  KeyboardAccessoryToolbar.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 04.11.2020.
//

import UIKit

final class KeyboardAccessoryToolbar : UIToolbar
{
    convenience init()
    {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = UIColor.systemBlue

        let doneButton  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(KeyboardAccessoryToolbar.done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.items = [spaceButton, doneButton]

        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }

    @objc
    private func done()
    {
        // Tell the current first responder (the current text input) to resign.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    @objc
    private func cancel()
    {
        // Call "cancel" method on first object in the responder chain that implements it.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
