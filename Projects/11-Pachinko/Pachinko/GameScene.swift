//
//  GameScene.swift
//  Pachinko
//
//  Created by JC on 2/9/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLeftLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var ballsLeft = 5 {
        didSet {
            ballsLeftLabel.text = "Balls: \(ballsLeft)"
        }
    }
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        /**
         Blend modes determine how a node is drawn. .replace means "draw the background
         ignoring any alpha values"
         */
        background.blendMode = .replace
        
        // We place it one layer behind
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLeftLabel.text = "Balls: 5"
        ballsLeftLabel.horizontalAlignmentMode = .right
        ballsLeftLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLeftLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // SKPhysicsContactDelegate
        physicsWorld.contactDelegate = self
        
        var i = 0
        for xPosition in stride(from: 128, to: 897, by: 256) {
            if i % 2 == 0 {
                makeSlot(at: CGPoint(x: xPosition, y: 0), isGood: true)
            } else {
                makeSlot(at: CGPoint(x: xPosition, y: 0), isGood: false)
            }
            i += 1
        }
        
        for xPosition in stride(from: 0, to: 1025, by: 256){
            makeBouncer(at: CGPoint(x: xPosition, y: 0))
        }
        
        for _ in 0...4 {
            makeObstacle()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        if objects.contains(editLabel) {
            
            // editingMode = !editingMode // is the same as
            editingMode.toggle()
        } else {
            if editingMode {
                // Creating random size
                makeObstacle(location: location)
            } else if ballsLeft > 0 {
                let ball = SKSpriteNode(imageNamed: getBallSprites().randomElement() ?? "ballRed")
                
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                
                // Bounciness of the ball
                ball.physicsBody?.restitution = 0.4
                
                // Lets us know which node the ball node collided with
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position.x = location.x
                ball.position.y = 700
                
                // Giving a name to the node so we can recognise it at runtime
                ball.name = "ball"
                addChild(ball)
                
                ballsLeft -= 1
            }
        }
    }
    
    func getBallSprites() -> [String] {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("Images.bundle")

        do {
            let contents = try! fileManager.contentsOfDirectory(
                at: assetURL,
                includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey],
                options: .skipsHiddenFiles
            )

            var images = [String]()
            
            for item in contents {
                if item.lastPathComponent.contains("ball") {
                    let separated = item.lastPathComponent.split(separator: "@").map { String($0) }
                    images.append(separated.first!)
                }
            }
            
            return images
        }
    }
    
    func makeObstacle(location: CGPoint? = nil) {
        let size = CGSize(width: Int.random(in: 64...256), height: 16)
        //Creating box with random colors and size
        let obstacle = SKSpriteNode(
            color: UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1), alpha: 1
            ),
            size: size
        )
        
        // Think of the zRotation as the rotation of a screw
        obstacle.zRotation = CGFloat.random(in: 0...3)
        
        if let position = location {
            obstacle.position = position
        } else {
            obstacle.position.x = CGFloat.random(in: 0...1025)
            obstacle.position.y = CGFloat.random(in: SKSpriteNode(imageNamed: "bouncer").size.height...300)
        }
        
        obstacle.name = "obstacle"
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        addChild(obstacle)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        
        // isDynamic false makes an object static
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // Sets the slot as static
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballsLeft += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "obstacle" {
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode) {
        // SKEmitterNode create particle effects
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: contact.bodyA.node!, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: contact.bodyB.node!, object: nodeA)
        }
    }
    
}
