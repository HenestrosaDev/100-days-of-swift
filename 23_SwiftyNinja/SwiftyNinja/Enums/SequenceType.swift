//
//  SequenceType.swift
//  SwiftyNinja
//
//  Created by JC on 19/9/21.
//

import Foundation

// CaseIterable portocol adds an allCases propery to the enum
enum SequenceType: CaseIterable {
    case oneNoBomb, // One penguin showing (no bombs)
         one, // One node (might be or not a bomb)
         twoWithOneBomb, // One is a bomb and two are penguins
         // Random enemies
         two,
         three,
         four,
         // Enemy chains don't wait until the previous enemy is offscreen before creating a new one, so it's like throwing five enemies quickly but with a small delay between each one.
         chain,
         fastChain,
         fastEnemy
}
