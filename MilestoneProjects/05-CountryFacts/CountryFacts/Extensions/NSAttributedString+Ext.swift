//
//  NSAttributedString+Ext.swift
//  CountryFacts
//
//  Created by JC on 11/4/23.
//

import UIKit

extension NSAttributedString {
 
    static func attributedText(
        withString string: String,
        boldString: String,
        font: UIFont = UIFont.systemFont(ofSize: 17)
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [NSAttributedString.Key.font: font]
        )
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)
        ]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        return attributedString
    }
    
}
