//
//  String+Ext.swift
//  Hangman
//
//  Created by JC on 2/4/23.
//

extension String {
    
    public mutating func setCharAt(_ index: Int, _ new: String) {
        let i = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(i...i, with: new)
    }
    
}
