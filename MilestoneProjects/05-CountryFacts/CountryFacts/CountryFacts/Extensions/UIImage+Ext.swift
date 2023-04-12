//
//  UIImage+Ext.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit

extension UIImage {
    
    func getImageRatio() -> CGFloat {
        let widthRatio = CGFloat(size.width / size.height)
        return widthRatio
    }
    
    static func scale(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
}
