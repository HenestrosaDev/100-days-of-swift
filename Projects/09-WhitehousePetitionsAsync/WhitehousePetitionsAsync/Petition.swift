//
//  Petition.swift
//  WhitehousePetitionsAsync
//
//  Created by JC on 1/9/21.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
