//
//  ProgressShowable.swift
//
//  Created by Serg Liamtsev on 5/20/19.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//

import UIKit

protocol ProgressShowable
{
    
    func showProgress()
    func hideProgress()
}

extension ProgressShowable where Self: BaseViewController
{
    func showProgress()
    {
        executeOnMain { [weak self] in
            guard let self = self else { return }
            
            self.addChild(self.hudElement)
            self.hudElement.view.frame = self.view.frame
            self.view.addSubview(self.hudElement.view)
            self.hudElement.didMove(toParent: self)
            
        }
    }
    
    func hideProgress()
    {
        executeOnMain { [weak self] in
            
            self?.hudElement.willMove(toParent: nil)
            self?.hudElement.view.removeFromSuperview()
            self?.hudElement.removeFromParent()
        }
    }    
}
