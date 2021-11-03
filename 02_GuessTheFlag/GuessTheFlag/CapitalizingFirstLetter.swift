//
//  CapitalizingFirstLetter.swift
//  GuessTheFlag
//
//  Created by JC on 25/8/21.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
