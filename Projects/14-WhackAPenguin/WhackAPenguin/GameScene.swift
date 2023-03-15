//
//  GameScene.swift
//  WhackAPenguin
//
//  Created by JC on 9/9/21.
//

import SpriteKit

class GameScene: SKScene {

    /**
     The pace at which the penguins spawn. It will be modified because, the more we play the less
     time will pass till the next penguin spawns (dynamic spawn).
     */
    var popupTime = 0.85
    var slots = [WhackSlot]()
    var scoreLabel: SKLabelNode!
    var numRounds = 0 //When >= 30, the game finishes
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        // We wait 1 second for the player to get ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            [weak self] in
            self?.createEnemy()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch  = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNotes = nodes(at: location)
        
        for node in tappedNotes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            
            whackSlot.hit()
            
            if node.name == "penguinGood" {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "penguinEvil" {
                whackSlot.penguinNode.xScale = 0.85
                whackSlot.penguinNode.yScale = 0.85
                
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            gameOver()
        }
        
        // The pace will fasten at 0.991 rate (arbitrary pace, but it has to be less than 1)
        popupTime *= 0.991
        
        slots.shuffle()
        
        // Shows and hides at the same speed
        slots[0].show(hideTime: popupTime)
        
        //Each condition makes a penguin to pop up. It's based on probability.
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        let delay = Double.random(in: minDelay...maxDelay)
        
        // After the random delay, create a new enemy again
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
    
    func gameOver() {
        for slot in slots {
            slot.hide()
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        scoreLabel.isHidden = true
        
        let finalScore = SKLabelNode(text: "Your final score is \(score)")
        finalScore.position = CGPoint(x: 512, y: 300)
        finalScore.zPosition = 1
        addChild(finalScore)
        
        run(SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false)) {
            self.isPaused = true
        }
    }
}
