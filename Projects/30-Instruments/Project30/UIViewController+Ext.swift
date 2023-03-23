//
//  UIViewController+Ext.swift
//  Project30
//
//  Created by JC on 23/3/23.
//  Copyright © 2023 Hudzilla. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
