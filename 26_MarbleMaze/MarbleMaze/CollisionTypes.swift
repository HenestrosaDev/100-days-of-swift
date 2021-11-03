//
//  CollisionTypes.swift
//  MarbleMaze
//
//  Created by JC on 22/9/21.
//

import Foundation

// The numbers double because when you combine them, they won't collide with other existing values. For example, player + wall + star + vortex = 15. player + vortex = 9
enum CollisionTypes: UInt32, CaseIterable {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    
    static func withLabel(_ label: String) -> CollisionTypes? {
        return self.allCases.first{ "\($0)" == label }
    }
}
