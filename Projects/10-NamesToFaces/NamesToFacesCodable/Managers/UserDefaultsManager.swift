//
//  UserDefaultsManager.swift
//  NamesToFaces
//
//  Created by JC on 5/4/23.
//

import Foundation

enum UserDefaultsKeys: String {
    case people = "people"
}

class UserDefaultsManager {
    
    /**
     Saves an object of the generic type `T` to UserDefaults using the specified key.

     - Parameters:
         - object: The object to save.
         - key: The key to use to store the object in UserDefaults.

     - Precondition: `T` must conform to the `Codable` protocol.
     
     - Postcondition: The object is encoded using JSONEncoder and saved to UserDefaults using the
     specified key.
    */
    static func save<T: Codable>(_ object: T, forKey key: UserDefaultsKeys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }
    
    /**
     Retrieves an object of the generic type `T` from UserDefaults using the specified key.

     - Parameters:
         - key: The key to use to retrieve the object from UserDefaults.

     - Returns: The decoded object of type `T`, or `nil` if no object was found for the specified key.

     - Precondition: `T` must conform to the `Codable` protocol.

     - Postcondition: The data for the specified key is retrieved from UserDefaults, decoded using
     JSONDecoder, and returned as an object of type `T`.
    */
    static func get<T: Codable>(forKey key: UserDefaultsKeys) -> T? {
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        
        return nil
    }
    
}

