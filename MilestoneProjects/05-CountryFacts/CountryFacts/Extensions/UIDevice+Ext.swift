//
//  UIDevice+Ext.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit.UIDevice
import CoreHaptics

extension UIDevice {
    
    static var isHapticAvailable: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    internal enum Haptic {
        case cell
        case button
    }
    
    static func hapticFeedback(from element: Haptic, isSuccessful: Bool = true) {
        switch element {
        case .cell:
            let generator = UIImpactFeedbackGenerator(
                style: isSuccessful ? .medium : .soft
            )
            generator.impactOccurred(intensity: 1.0)
        
        case .button:
            let generator = UINotificationFeedbackGenerator()
            
            if isSuccessful {
                generator.notificationOccurred(.success)
            } else {
                generator.notificationOccurred(.error)
            }
        }
    }
}

