//
//  UIViewController+Ext.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit.UIViewController
import SafariServices

extension UIViewController {
    
    func openSafari(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .automatic
        present(safariVC, animated: true)
    }
    
}
