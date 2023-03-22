//
//  Int+Ext.swift
//  ExplodingMonkeys
//
//  Created by JC on 21/3/23.
//

import Foundation

extension Int {
    
    // Used for converting degrees to Radians. Useful for banana spin animation.
    func toRadians() -> Double {
        return Double(self) * Double.pi / 180
    }
    
}
