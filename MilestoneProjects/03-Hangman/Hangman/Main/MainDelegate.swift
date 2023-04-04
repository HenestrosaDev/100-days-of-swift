//
//  MainDelegate.swift
//  Hangman
//
//  Created by JC on 29/3/23.
//

import Foundation

protocol MainDelegate: AnyObject {
    func didTapLetterButton(letter: String)
    func didTapTopScoresBt()
}
