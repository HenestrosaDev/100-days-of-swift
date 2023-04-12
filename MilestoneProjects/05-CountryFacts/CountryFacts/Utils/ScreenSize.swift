//
//  ScreenSize.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let maxWidth = min(ScreenSize.width, ScreenSize.height)
}
