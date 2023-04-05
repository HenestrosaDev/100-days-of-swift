//
//  Person.swift
//  NamesToFaces
//
//  Created by JC on 2/9/21.
//

import UIKit

/**
 - This has to be a class instead of a struct is because we cannot use NSCoding with structs
 - NSObject is necessary to use NSCoding
 - NSCoding is necessary for saving the people array to UserDefaults. Kind of Serializable in Android.
 It's backwards compatible with Objective-C, unlike the Codable protocol that does the same only
 for Swift. It's much more simpler.
 */
class Person: NSObject, NSCoding {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // NSCoder is responsible for encoding and decoding so it can be used with UserDefaults
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
}
