//
//  MainViewController.swift
//  Hangman
//
//  Created by JC on 29/3/23.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Properties
    
    private var mainView: MainView!
    
    private var words = [String]()
    private var wordToPromptIndex = 0
    private var lives = 3 {
        didSet {
            mainView.updateLivesLb(lives: lives)
        }
    }
    private var score = 0 {
        didSet {
            mainView.updateScoreLb(score: score)
        }
    }
    private var wrongAnswers = 0 {
        didSet {
            mainView.updateHangmanIv(position: wrongAnswers)
            if wrongAnswers == 7 {
                lives -= 1
                
                if lives > 0 {
                    presentAlert(
                        title: currentWord,
                        titleColor: .systemRed,
                        message: "Score: \(score) • Lives: \(lives)",
                        buttonTitle: "Next"
                    ) { [weak self] in
                        self?.loadNewWord()
                    }
                } else {
                    presentAlert(
                        title: currentWord,
                        titleColor: .systemRed,
                        message: "Game over! Your final score is \(score)",
                        buttonTitle: "New Game"
                    ) { [weak self] in
                        self?.saveScore()
                        self?.loadNewGame()
                    }
                }
            }
        }
    }
    private var usedLetters = [String]()
    private var currentWord: String {
        words[wordToPromptIndex]
    }
    private var currentPromptedWord: String! {
        didSet {
            mainView.updateWordLb(word: currentPromptedWord)
        }
    }
    
    // MARK: - Lifecyle
    
    override func loadView() {
        loadWords()
        mainView = MainView(delegate: self)
        currentPromptedWord = String(currentWord.unicodeScalars.map { _ in "_" })
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func loadWords() {
        if let wordsUrl = Bundle.main.url(forResource: "words-en", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: wordsUrl) {
                let words = levelContents.components(separatedBy: "\n")
                let uppercasedWords = words.map { $0.uppercased() }
                self.words = uppercasedWords.shuffled()
            }
        }
    }
    
    private func reset() {
        mainView.enableLetterBts()
        usedLetters = []
        wrongAnswers = 0
    }
    
    private func loadNewGame() {
        reset()
        score = 0
        lives = 3
        wordToPromptIndex = 0
        words.shuffle()
        currentPromptedWord = String(currentWord.unicodeScalars.map { _ in "_" })
    }
    
    private func loadNewWord() {
        reset()
        wordToPromptIndex += 1
        currentPromptedWord = String(currentWord.unicodeScalars.map { _ in "_" })
    }
    
    private func saveScore() {
        let scores = UserDefaultsManager.get(forKey: .scores) as [Int]?
        guard var scores = scores else {
            UserDefaultsManager.save([score], forKey: .scores)
            return
        }
        
        // Limit the stored scores to 3
        if scores.count < 3 {
            scores.append(score)
        } else {
            for (index, score) in scores.enumerated() where score < self.score {
                scores[index] = self.score
                break
            }
        }
        
        UserDefaultsManager.save(scores.sorted(), forKey: .scores)
    }

}

// MARK: - Delegate Conformance
extension MainViewController: MainDelegate {
    
    func didTapLetterButton(letter: String) {
        usedLetters.append(letter)
        var newPromptWord = ""
        
        for letter in currentWord {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                newPromptWord += strLetter
            } else {
                newPromptWord += "_"
            }
        }
        
        if currentPromptedWord == newPromptWord {
            wrongAnswers += 1
        } else {
            currentPromptedWord = newPromptWord
            
            if !currentPromptedWord.contains("_") {
                score += 1
                
                presentAlert(
                    title: currentWord,
                    titleColor: .systemGreen,
                    message: "Score: \(score) • Lives: \(lives)",
                    buttonTitle: "Next"
                ) { [weak self] in
                    self?.loadNewWord()
                }
            }
        }
    }
    
    func didTapTopScoresBt() {
        let scores = UserDefaultsManager.get(forKey: .scores) as [Int]?
        var scoresString = ""
        
        if let scores = scores {
            for (index, score) in scores.reversed().enumerated() {
                scoresString += "\(index + 1). \(score)\n"
            }
            
            // Remove last new line, which is unnecessary
            scoresString = String(scoresString.dropLast(1))
        } else {
            scoresString += "There are no scores yet - go play!"
        }
        
        presentAlert(
            title: "TOP SCORES",
            titleColor: .white,
            message: scoresString,
            buttonTitle: "Close"
        )
    }
    
}
