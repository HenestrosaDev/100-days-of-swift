//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by JC on 24/8/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var buttonTapped: UIButton!
    
    var countries = [String]()
    var score = 0
    var questionNumber = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // (Day 73) Challenge of instructor
        NotificationHandler.instance.askForPermission()
        NotificationHandler.instance.scheduleAlerts()
        //
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScore))
        
        countries += [
            "estonia",
            "france",
            "germany",
            "ireland",
            "italy",
            "monaco",
            "nigeria",
            "poland",
            "russia",
            "spain",
            "uk",
            "us"
        ]
        
        /**
         The measure of the border is in points.
         For retina devices, it's the same as 2px. For retina HD devices, is 3px.
         */
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        /**
         We can't put UIColor.lightGray property directly into our border color property
         because it belongs to a CA layer, which doesn't know where UI color is. That's
         why we convert it into a cgColor.
         */
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // In case that we want to custom the color:
        // button3.layer.borderColor = UIColor(red: 1.1, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        
        askQuestion()
        print(getMaxScore())
    }

    func askQuestion(action: UIAlertAction? = nil) {
        if buttonTapped != nil { buttonTapped.transform = .identity }
        
        // Randomizes the position of the items of the array
        countries.shuffle()
        
        // We do the same with the correct answer getting a random value between 0 and 2
        correctAnswer = Int.random(in: 0...2)
        
        /**
         for: describes which state of the button should be changed.
         Looks like a enumm but it's actually but is actually a static property of a struct called
         UIControlState. In C, it's an enum but in Swift it gets mapped to a struct that just
         happens to be used like an enum.
         */
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        questionNumber += 1
        
        title = "\(countries[correctAnswer])".uppercased() + "   \(questionNumber)/10"
    }
    
    //onClickListener()
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String! = nil
        var message: String! = nil
        
        buttonTapped = sender
        animate(sender)
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        message = "Your score is \(score)"
        
        if title == "Wrong" {
            message = "You tapped on the \(countries[sender.tag].capitalizingFirstLetter()) flag"
        }
        
        if questionNumber + 1 > 10 {
            title = "That's it! Thanks for playing :)"
            if score > getMaxScore() {
                save()
            }
        }
            
        // UI alert is the same as AlertDialog in Android
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        /**
         - Adds a button to the alert
         - Three possible styles: .default, .cancel and .destructive
         - IMPORTANT: We use askQuestion as the handler instead of askQuestion() because we use it
         as a reference. It will be executed when we tap the action. If we called the function
         instead, we wold be executing the function as soon as the compiler compiles it.
         */
        if questionNumber + 1 <= 10 {
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        } else {
            alertController.addAction(UIAlertAction(title: "Bye bye", style: .default) { _ in
               // Right after the user presses "ok", the following code will be execute
               exit(-1)
            })
        }
        
        /**
         It's like the show() method. We have to specify which alertController we want to show and
         if we want it animated or not.
         */
        present(alertController, animated: true)
    }
    
    @objc func showScore() {
        var message = "\(score) points. "
        switch score {
        case 0...4: message += "You can do better!"
        case 5...6: message += "Fair enough"
        case 7...8: message += "You're doing great!"
        case 9: message += "Damn good job"
        default: message += "Something went wrong"
        }
        
        let alertController = UIAlertController(title: "Score", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func getMaxScore() -> Int {
        let defaults = UserDefaults.standard
        if let savedScore = defaults.object(forKey: "maxScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                return try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(score) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "maxScore")
        }
    }
    
    // Challenge of instructor (day 58)
    func animate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
}
