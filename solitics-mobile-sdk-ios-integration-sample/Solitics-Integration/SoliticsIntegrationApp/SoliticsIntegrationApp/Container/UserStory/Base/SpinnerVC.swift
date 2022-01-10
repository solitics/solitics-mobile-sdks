//
//  SpinnerVC.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 05.11.2020.
//
import UIKit
///
///
///
final class SpinnerVC : UIViewController
{
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func loadView()
    {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
