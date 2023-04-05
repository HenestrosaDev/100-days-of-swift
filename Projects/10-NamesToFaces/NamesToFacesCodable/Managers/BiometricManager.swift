//
//  BiometricManager.swift
//  NamesToFacesCodable
//
//  Created by JC on 5/4/23.
//

import LocalAuthentication

class BiometricManager {
    
    // Day 93 challenge
    static func insertBiometricAuthentication(completion: @escaping (_ success: Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        /**
         &error => LocalAuthentication framework uses Objective-C (that's why the type of the
         error variable is NSError). We pass the error argument as a reference to our error
         variable, which then changes its value inside the canEvaluatePolicy() method. It's similar
         to inout parameters in Swift.
         */
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "To access sensible content, you must identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            completion(false)
        }
    }
    
}
