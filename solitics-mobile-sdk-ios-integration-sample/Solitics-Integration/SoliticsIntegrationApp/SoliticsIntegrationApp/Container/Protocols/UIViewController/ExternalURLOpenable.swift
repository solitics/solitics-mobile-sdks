//
//  ExternalURLOpenable.swift
//
//  Created by Serg Liamtsev on 6/6/19.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//

import SafariServices
import UIKit

protocol ExternalURLOpenable
{
    func openURL(_ urlString: String)
    func openURL(_ url: URL)
}

extension ExternalURLOpenable where Self: BaseViewController
{
    func openURL(_ urlString: String)
    {
        guard let url = URL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true, completion: nil)
    }
    
    func openURL(_ url: URL)
    {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true, completion: nil)
    }
}
