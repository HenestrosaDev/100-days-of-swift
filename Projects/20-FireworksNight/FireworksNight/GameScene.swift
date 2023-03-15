//
//  GameScene.swift
//  FireworksNight
//
//  Created by JC on 14/9/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var rounds = 0 // Challenge 2 of instructor
    var scoreLabel: SKLabelNode! // Challenge 1 of instructor
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Challenge 1 of instructor
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        // Makes the node fully colored by the color we chose
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        // Contains the trajectory of the fireworks
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        /**
         follow() makes the node move along the path specified as path.cgPath. asOffset makes the
         path start where the sprite starts. orientToPath makes the firework move towards the path.
         */
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        if rounds < 10 { // Challenge 2 of instructor
            let movementAmount: CGFloat = 1800
            
            switch Int.random(in: 0...3) {
            case 0:
                // 5 fireworks, straight up
                for i in stride(from: -200, to: 201, by: 100) {
                    createFirework(xMovement: 0, x: 512 + i, y: bottomEdge)
                }
            case 1:
                // 5 fireworks, in a fan
                for i in stride(from: -200, to: 201, by: 100) {
                    createFirework(xMovement: CGFloat(i), x: 512 + i, y: bottomEdge)
                }
            case 2:
                // 5 fireworks, from left to right
                for i in stride(from: 400, to: -1, by: -100) {
                    createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + i)
                }
            case 3:
                // 5 fireworks, from right to left
                for i in stride(from: 400, to: -1, by: -100) {
                    createFirework(xMovement: movementAmount, x: rightEdge, y: bottomEdge + i)
                }
            default:
                break
            }
            
            rounds += 1 // Challenge 2 of instructor
        } else {
            // Challenge 2 of instructor
            gameTimer?.invalidate()
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
        }
        
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        /**
         "case let as" checks if the element inside the array (nodesAtPoint) can be casted as
         SKSpriteNode. If so, go into the loop.
         node is the SKSpriteNode that the player just selected.
         */
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            /**
             This loop ensures that the player selects only one firework at a time. If they select
             red then another red, both are selected but, if they select a green instead of a red,
             we deselect the first red because we need two reds.
             */
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    // We put the firework but to its original color
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            // Makes the node to go back to the default texture color, which is white
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    /**
     Here, we handle those fireworks that the player doesn't destroy. If they past 900 points up
     vertically, then we remove them from the array and the parent. We need to move down backwards
     because if we remove the 3rd element, then the 4th element moves down to become 3.
     */
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explodeEmitter(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            // Challenge 3 of instructor
            let delayedRemoval = SKAction.sequence([
                        SKAction.wait(forDuration: 3),
                        SKAction.removeFromParent(),
                    ])
            
            emitter.position = firework.position
            emitter.run(delayedRemoval)
            
            addChild(emitter)
        }

        firework.removeFromParent()
    }
    

    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                explodeEmitter(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
