//
//  Person.swift
//  NamesToFaces
//
//  Created by JC on 2/9/21.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
