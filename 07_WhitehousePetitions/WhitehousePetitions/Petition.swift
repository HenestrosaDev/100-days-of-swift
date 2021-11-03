//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by JC on 29/8/21.
//

import Foundation

struct Petition : Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
