//
//  File.swift
//  StormViewer
//
//  Created by JC on 7/9/21.
//

import UIKit

class Picture: NSObject, Codable {
    
    var path: String
    var views: Int
    
    init(path: String, views: Int) {
        self.path = path
        self.views = views
    }
}
