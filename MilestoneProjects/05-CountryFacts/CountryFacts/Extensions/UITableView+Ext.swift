//
//  UITableView+Ext.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit.UITableView

extension UITableView {
    
    func setEmptyMessage(_ message: String = "No Results") {
        let messageLabel = UILabel(
            frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        )
        
        messageLabel.text = message
        messageLabel.textColor = .systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 26)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restoreInitialState() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
