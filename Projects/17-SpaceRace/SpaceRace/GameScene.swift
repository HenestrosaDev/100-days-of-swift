//
//  GameScene.swift
//  SpaceRace
//
//  Created by JC on 12/9/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    // Challenge 1 of instructor
    var isGrabbed: Bool!
    
    // Challenge 2 of instructor
    var debrisCounter = 0
    var timeInterval = 1.0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)

        // Create 10 seconds worth of particles
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)

        /**
         This will match the category bit mask we will set for space debris later on, and it means
         that we'll be notified when the player collides with debris.
         */
        player.physicsBody?.contactTestBitMask = 1
        player.name = "player"
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        // This will trigger the didSet of score
        score = 0
        
        physicsWorld.gravity = .zero
        
        // Tells us when contacts happen
        physicsWorld.contactDelegate = self
        
        // Creates an enemy 3 times per second (OG method)
        // gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        // Challenge 2 of instructor
        gameTimer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(createEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        // For each frame update that the player survives, we add 1 point
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch  = touches.first else { return }
        var location = touch.location(in: self)
        
        // Challenge 1 of instructor
        let touchedNode = atPoint(location)

        if let name = touchedNode.name {
            if name == "player" {
                isGrabbed = true
            }
        }
        
        if isGrabbed == true {
            // End of challenge 1 (in this block)
            if location.y < 100 {
                location.y = 100
            } else if location.y > 668 {
                location.y = 668
            }
            
            player.position = location
        }
    }
    
    // Challenge 1 of instructor
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isGrabbed = false
    }
    
    // Remember, this method is called when a collision between two nodes happen
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        // Challenge 3 of instructor
        gameTimer?.invalidate()
        
        // Personal challenge
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        isPaused = true
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        // Matches the category bit mask of the player
        sprite.physicsBody?.categoryBitMask = 1
        
        // Moves fastly to the left at a constant
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        
        // It'll spin through the air as it's moving
        sprite.physicsBody?.angularVelocity = 5
        
        // Both of these properties simulate the friction
        
        // Controls how fast things slow down over time. 0 means that it won't
        sprite.physicsBody?.linearDamping = 0
        
        // Same as above but with the spinning. 0 means it'll never stop
        sprite.physicsBody?.angularDamping = 0
        
        // Challenge 2 of instructor
        debrisCounter += 1
        if debrisCounter % 20 == 0 { speedUp() }
    }
    
    // Challenge 2 of instructor
    func speedUp() {
        gameTimer?.invalidate()
        timeInterval -= 0.1
        gameTimer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(createEnemy),
            userInfo: nil,
            repeats: true
        )
    }
}
