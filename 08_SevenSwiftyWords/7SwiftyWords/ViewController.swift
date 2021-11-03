//
//  ViewController.swift
//  SwiftyWords
//
//  Created by JC on 29/8/21.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel! //var cluesLabel = UILabel()
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var answersNumber = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        //We'll write the constraints by hand, so we set tamic as false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        //This indicates Auto layout that, in case of having to stretch something, this will have top priority for getting stretched
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
    
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        //Same as in Android enabled = false. The user won't e able to type on it
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        //onClickListener() = addTarget()
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsContainer = UIView()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            //60% of the width of our layout margins - 100 points (moves towards the left)
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            //20 points below cluesLabel.bottomAnchor
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            //Moves 100 points to the right of the center
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        
        for row in 0...3 {
            for column in 0...4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsContainer.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //performSelector(inBackground: #selector(loadLevel), with: nil)
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        //sender.isHidden = true
        animateAlpha(sender, 0)
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        //Tries to find the index of the solution that the user typed. If the answer matchs a solution using firstIndex(), then:
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            //We store the text of the answersLabel into an array
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            //Replaces the text "X letters" with the actual answer
            splitAnswers?[solutionPosition] = answerText
            //We put the array back together again and separate their elements by line breaks
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            answersNumber += 1
            
            //This checks whether we completed the level or not. We can only get 7 points por level, so if we have 7 points and then them by 7, the module of the division=0.
            if answersNumber == 7 {
                showAlert(title: "Well done", message: "Are you ready for the next level?", isLevelUp: true)
            }
        } else {
            showAlert(title: "Incorrect", message: "\(answerText) is not a valid answer", isLevelUp: false)
        }
    }
    
    func showAlert(title: String, message: String, isLevelUp: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if isLevelUp {
            alertController.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                self.score -= 1
            })
        }
        present(alertController, animated: true)
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1

        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            animateAlpha(button, 1)
            //button.isHidden = false
        }
    }
    
    //Resets the answer and shows back the hidden buttons
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            animateAlpha(button, 1)
            //button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    @objc func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterChars = [String]()
        
        if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileUrl) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                //We use a tuple because lines.enumerated() returns two values
                for (index, line) in lines.enumerated() {
                    //Splits a line into two parts separated by ": "
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    //HE|LLO to HE LLO. HE represents a button and LLO another one.
                    let chars = answer.components(separatedBy: "|")
                    letterChars += chars
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterChars.count {
            for i in 0..<letterChars.count {
                letterButtons[i].setTitle(letterChars[i], for: .normal)
                //Challenge of the instructor
                letterButtons[i].layer.borderWidth = 1
                letterButtons[i].layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    //Challenge of the instructor (day 58)
    func animateAlpha(_ button: UIButton, _ alpha: Int) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            button.alpha = CGFloat(alpha)
        })
    }
    
}

