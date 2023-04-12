//
//  DeviceTypes.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit

enum DeviceTypes {
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = ScreenSize.maxLength == 896.0
    static let isiPad = ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool { return isiPhoneX || isiPhoneXsMaxAndXr    }
}
