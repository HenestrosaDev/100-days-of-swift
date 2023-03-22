//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by JC on 20/3/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: Public Properties
    
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var player1TurnLabel: UILabel!
    @IBOutlet weak var player2TurnLabel: UILabel!
    
    //Challenge 1
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    // Challenge 3
    @IBOutlet weak var windLabel: UILabel!
    var wind: Wind!
    
    /**
     Necessary for communicating the user interface's value changes to the GameScene.
     The GameViewController strongly owns the game scene indirectly (it owns the SKView), so we
     just need to add a strong reference to access the GameScene.
     */
    var currentGame: GameScene?
    
    // Challenge 1
    var isGameFinished = false {
        didSet {
            newGameButton.isHidden = !isGameFinished
        }
    }
    
    // MARK: Private Properties
    
    // Challenge 1
    private var player1Score: Int = 0 {
        didSet {
            player1ScoreLabel.text = "SCORE: \(player1Score)"
        }
    }
    private var player2Score: Int = 0 {
        didSet {
            player2ScoreLabel.text = "SCORE: \(player2Score)"
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Challenge 3
        wind = Wind.getRandomWind()
        windLabel.attributedText = wind.getText()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        didChangeAngleSlider(self)
        didChangeVelocitySlider(self)
    }

    // MARK: - Overriden Methods
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Public Methods
    
    func activatePlayer(number: Int) {
        // Challenge 3
        wind = Wind.getRandomWind()
        windLabel.attributedText = wind.getText()
        
        if number == 1 {
            player1TurnLabel.isHidden = false
            player2TurnLabel.isHidden = true
        } else {
            player1TurnLabel.isHidden = true
            player2TurnLabel.isHidden = false
        }
        
        toggleControlsVisibility(shouldHide: false)
    }
    
    // Challenge 1
    func playerScored(playerNumber: Int) {
        if playerNumber == 1 {
            player1Score += 1
            if player1Score == 3 {
                player1TurnLabel.text = "PLAYER \(playerNumber) WINS"
                player2TurnLabel.isHidden = true
                finishGame()
            }
        } else {
            player2Score += 1
            if player2Score == 3 {
                player1TurnLabel.isHidden = true
                player2TurnLabel.text = "PLAYER \(playerNumber) WINS"
                finishGame()
            }
        }
    }
    
    // MARK: Private Methods
    
    private func toggleControlsVisibility(shouldHide: Bool) {
        angleSlider.isHidden = shouldHide
        angleLabel.isHidden = shouldHide
        
        velocitySlider.isHidden = shouldHide
        velocityLabel.isHidden = shouldHide
        
        launchButton.isHidden = shouldHide
        windLabel.isHidden = shouldHide
    }
    
    // Challenge 1
    private func finishGame() {
        toggleControlsVisibility(shouldHide: true)
        isGameFinished = true
    }
    
    // MARK: Action Methods
    
    @IBAction func didChangeAngleSlider(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func didChangeVelocitySlider(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func didTapLaunchButton(_ sender: Any) {
        toggleControlsVisibility(shouldHide: true)
        currentGame?.launchBanana(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    // Challenge 1
    @IBAction func didTapNewGameButton(_ sender: Any) {
        isGameFinished = false
        player1Score = 0
        player2Score = 0
        currentGame?.newGame()
    }
    
}
