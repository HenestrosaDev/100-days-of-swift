//
//  Petitions.swift
//  WhitehousePetitions
//
//  Created by JC on 29/8/21.
//

import Foundation

struct Petitions : Codable {
    // The name of the variable MUST match the name of the node that we want to get from the JSON
    var results: [Petition]
}
