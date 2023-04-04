//
//  UIViewController+Ext.swift
//  Hangman
//
//  Created by JC on 2/4/23.
//

import UIKit

extension UIViewController {
    
    func presentAlert(
        title: String,
        titleColor: UIColor,
        message: String?,
        buttonTitle: String,
        completionButton: (() -> Void)? = nil
    ) {
        let alertVC = AlertViewController(
            title: title,
            titleColor: titleColor,
            message: message,
            buttonTitle: buttonTitle,
            completionButton: completionButton
        )
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve // presentation animation
        self.present(alertVC, animated: true)
    }
    
}
