//
//  ViewController.swift
//  WordScramble
//
//  Created by JC on 28/8/21.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    //usedWords are the player's answers for each word. Once he gets it right, then we empty it.
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        //Challenge of the instructor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        //Looks for afile named start.txt in the bundle of the project
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //We parse the elements of the start file to String. With contentsOf we say that we are going to extract those strings from startWorldsURL (the path of the file)
            if let startWordsFromFile = try? String(contentsOf: startWordsURL) {
                allWords = startWordsFromFile.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
           allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        //The closure is the handler
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            //[weak self, weak alertController] declares the parameters coming into the closure. They can be strong, weak and/or unowned. The Readme has more details about these terms. self makes reference to the ViewController of the class itself
            [weak self, weak alertController] _ in
            //alertController?.textFields?[0].text get the text from the first textfield of the alertController
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer.lowercased())
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    func submit(_ answer: String) {
        guard let title = title else { return }
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) && !isRepeated(word: lowerAnswer) && isReal(word: lowerAnswer) && isShort(word: lowerAnswer) && !isExplicitlyInTheWord(word: lowerAnswer) {
            //If the answer is valid, then we add it to the usedWords array and add it to the top of the table (indexPath 0 at 0)
            usedWords.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        } else {
            if isExplicitlyInTheWord(word: lowerAnswer) {
                showErrorMessage(title: "\(answer) is explicit in \(title)", message: "The game would be too easy this way, don't you think?")
            }
            if !isShort(word: lowerAnswer) {
                showErrorMessage(title: "Word too short", message: "It has to be larger than 2 characters")
            }
            if !isReal(word: lowerAnswer) {
                showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know?")
            }
            if isRepeated(word: lowerAnswer) {
                showErrorMessage(title: "World already used", message: "Be careful")
            }
            if !isPossible(word: lowerAnswer) {
                showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title.lowercased())")
            }
        }
    }
    
    //Challenge of the instructor
    func showErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var wordTmp = title?.lowercased() else { return false }
        
        //Looping over all the letters in the input word
        for letter in word {
            if let position = wordTmp.firstIndex(of: letter) {
                //If a letter of the input word is found in the wordTmp, then we remove the founded letter from the wordTmp, so we can't use the same letter twice
                wordTmp.remove(at: position)
            } else {
                return false
            }
        }
        //If all the letters have been found, then we say that it is possible
        return true
    }
    
    func isRepeated(word: String) -> Bool {
        return usedWords.contains(word)
    }
    
    //Checks whether the word is in the English dictionary or not.
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        //We need to convert Swift strings to Objective-C strings. We need to use 16-bit Unicode transformation format because: Swift "é" and Objc "e´". UIKit was written in Objc so we need to use its codification of Strings.
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspellRange.location == NSNotFound
    }
    
    func isShort(word: String) -> Bool {
        return word.count > 2
    }
    
    func isExplicitlyInTheWord(word: String) -> Bool {
        guard let wordTmp = title?.lowercased() else { return false }
        return wordTmp.contains(word)
    }

}
