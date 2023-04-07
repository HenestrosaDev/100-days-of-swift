//
//  UIViewController+Ext.swift
//  PhotoCaptions
//
//  Created by JC on 6/4/23.
//

import UIKit

extension UIViewController {
    
    func getDocumentsDirectory() -> URL {
        // `in`: adds that we want the path to be relative to the user's home directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
