//
//  ImageUtils.swift
//  CountryFacts
//
//  Created by JC on 12/4/23.
//

import Foundation

struct ImageUtils {
    
    static let flagFileSuffix = "-sm.png"
    
    static func getFlagFileName(countryCode: String) -> String {
        return "\(countryCode)\(flagFileSuffix)"
    }
    
}
