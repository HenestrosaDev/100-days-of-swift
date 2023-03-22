//
//  Wind.swift
//  ExplodingMonkeys
//
//  Created by https://github.com/clarknt
//

import UIKit

// Challenge 3
public struct Wind {
    
    enum HDirection {
        case left
        case right
        case none
    }
    
    enum VDirection {
        case up
        case down
        case none
    }
    
    enum Speed: CaseIterable {
        case slow
        case medium
        case fast
    }

    var letter: String
    var hDir: HDirection
    var vDir: VDirection
    var speed: Speed
    
    func getText() -> NSAttributedString {
        let letterAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: getColor()]
        let windAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        
        let firstString = NSMutableAttributedString(string: letter, attributes: letterAttributes)
        let secondString = NSAttributedString(string: " WIND ", attributes: windAttributes)
        let thirdString = NSAttributedString(string: letter, attributes: letterAttributes)

        firstString.append(secondString)
        firstString.append(thirdString)

        return firstString
    }
    
    func getColor() -> UIColor {
        if hDir == .none && vDir == .none {
            return UIColor.green
        }
        
        switch speed {
        case .slow:
            return UIColor.yellow
        case .medium:
            return UIColor.orange
        case .fast:
            return UIColor.red
        }
    }
    
    func getGravity(player: Int) -> CGVector {
        let gravityModifier = getSpeedGravityModifier()
        let hGravity = getHorizontalGravity(player: player, gravityModifier: gravityModifier)
        let vGravity = getVerticalGravity(gravityModifier: gravityModifier)
        
        return CGVector(dx: hGravity, dy: vGravity)
    }
    
    private func getHorizontalGravity(player: Int, gravityModifier: Double) -> Double {
        var hGravity: Double = 0
        
        switch hDir {
        case .left:
            hGravity -= gravityModifier
        case .right:
            hGravity += gravityModifier
        case .none:
            break
        }
        
        return hGravity
    }
    
    private func getVerticalGravity(gravityModifier: Double) -> Double {
        var vGravity: Double = -9.8
        
        switch vDir {
        case .up:
            vGravity += gravityModifier
        case .down:
            vGravity -= gravityModifier
        case .none:
            break
        }
        
        return vGravity
    }
    
    private func getSpeedGravityModifier() -> Double {
        var speedModifier: Double = 0
        
        switch speed {
        case .slow:
            speedModifier = 1
        case .medium:
            speedModifier = 2
        case .fast:
            speedModifier = 3
        }

        // If wind blows diagonally, share the speed between each direction
        if hDir != .none && vDir != .none {
            return speedModifier / 2
        }

        return speedModifier
    }
    
    static func getRandomWind() -> Wind {
        let speed = Speed.allCases.randomElement()!
        
        let winds = [
            Wind(letter: "↑", hDir: .none, vDir: .up, speed: speed),
            Wind(letter: "↗", hDir: .right, vDir: .up, speed: speed),
            Wind(letter: "→", hDir: .right, vDir: .none, speed: speed),
            Wind(letter: "↘", hDir: .right, vDir: .down, speed: speed),
            Wind(letter: "↓", hDir: .none, vDir: .down, speed: speed),
            Wind(letter: "↙", hDir: .left, vDir: .down, speed: speed),
            Wind(letter: "←", hDir: .left, vDir: .none, speed: speed),
            Wind(letter: "↖", hDir: .left, vDir: .up, speed: speed),
            Wind(letter: "-", hDir: .none, vDir: .none, speed: speed),
        ]

        return winds.randomElement()!
    }
}
