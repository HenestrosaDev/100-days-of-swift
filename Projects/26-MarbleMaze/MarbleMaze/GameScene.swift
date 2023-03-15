//
//  GameScene.swift
//  MarbleMaze
//
//  Created by JC on 22/9/21.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene {
    
    // MARK: Properties
    
    let nodeGen = NodeGenerator.instance
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Challenge 2
    var restartGameLabel: SKLabelNode!
    var restartLevelLabel: SKLabelNode!
    var nextLevelLabel: SKLabelNode!

    let maxLevel = 5
    var currentLevelLabel: SKLabelNode!
    var currentLevel = 1
    
    {
        didSet {
            currentLevelLabel.text = "Level: \(currentLevel)"
        }
    }
    
    // Challenge 3
    var isPortalActive = true
    
    // MARK: - Overriden Methods
    
    override func didMove(to view: SKView) {
        addBackground()
        addScore()
        addLevelLabel()
        loadLevel(currentLevel)
        loadPlayer()
        
        prepareFinishLabels()
        #if !targetEnvironment(simulator)
        loadMotionManager()
        #endif
        
        physicsWorld.contactDelegate = self
    }
    
    // For simulator
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        saveLastTouch(touch: touch)
        
        // Challenge 2
        nodes(at: lastTouchPosition!).forEach { node in
            if node.name == "nextLevel" {
                currentLevel += 1
                // I NEED TO HANDLE THIS BETTER
                if currentLevel > maxLevel {
                    currentLevel = 1
                }
                prepareForNextLevel()
            } else if node.name == "restartLevel" {
                prepareForNextLevel()
            } else if node.name == "restartGame" {
                score = 0
                currentLevel = 1
                prepareForNextLevel()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { saveLastTouch(touch: touch) }
    }
    
    func saveLastTouch(touch: UITouch) {
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(
                x: currentTouch.x - player.position.x,
                y: currentTouch.y - player.position.y
            )
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(
                dx: accelometerData.acceleration.y * -50,
                dy: accelometerData.acceleration.x * 50
            )
        }
        #endif
    }
    
    // MARK: - Methods
    
    private func loadLevel(_ level: Int) {
        let levelName = "level\(currentLevel)"
        
        guard let levelURL = Bundle.main.url(forResource: levelName, withExtension: "txt") else {
            fatalError("Could not find \(levelName).txt in the app bundle")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load \(levelName).txt from the app bundle")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        print(lines)
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                /**
                 64 because each square in the game world occupies 64x64, so we can find its
                 position by multiplying its row and column by 64. We need to add 32 to the X & Y
                 because SpriteKit calculates its positions from the center of objects.
                 */
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                // Challenge 1
                loadLevelElement(with: letter, at: position)
            }
        }
    }
    
    private func loadLevelElement(with letter: Character, at position: CGPoint) {
        switch letter {
        case "x":
            addChild(nodeGen.createNode(for: "wall", at: position))
        case "v":
            addChild(nodeGen.createNode(for: "vortex", at: position))
        case "s":
            addChild(nodeGen.createNode(for: "star", at: position))
        case "f":
            addChild(nodeGen.createNode(for: "finish", at: position))
        case "p":
            addChild(nodeGen.createNode(for: "portal", at: position))
        case " ":
            break
        default:
            fatalError("Unknown level element: \(letter)")
        }
    }
    
    private func loadPlayer() {
        player = nodeGen.createNode(for: "player", at: CGPoint(x: 96, y: 672))
        addChild(player)
    }
    
    private func prepareFinishLabels() {
        nextLevelLabel = SKLabelNode(fontNamed: "Chalkduster")
        nextLevelLabel.text = "Next Level"
        nextLevelLabel.fontSize = 48
        nextLevelLabel.name = "nextLevel"
        nextLevelLabel.horizontalAlignmentMode = .center
        nextLevelLabel.position = CGPoint(x: 512, y: 454)
        nextLevelLabel.zPosition = 2
        
        restartLevelLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLevelLabel.text = "Restart Level"
        restartLevelLabel.fontSize = 48
        restartLevelLabel.name = "restartLevel"
        restartLevelLabel.horizontalAlignmentMode = .center
        restartLevelLabel.position = CGPoint(x: 512, y: 384)
        restartLevelLabel.zPosition = 2
        
        restartGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartGameLabel.text = "Restart Game"
        restartGameLabel.fontSize = 48
        restartGameLabel.name = "restartGame"
        restartGameLabel.horizontalAlignmentMode = .center
        restartGameLabel.position = CGPoint(x: 512, y: 314)
        restartGameLabel.zPosition = 2
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    private func addLevelLabel() {
        currentLevelLabel = SKLabelNode(fontNamed: "Chalkduster")
        currentLevelLabel.text = "Level: \(currentLevel)"
        currentLevelLabel.horizontalAlignmentMode = .left
        currentLevelLabel.position = CGPoint(x: 16, y: 730)
        currentLevelLabel.zPosition = 2
        addChild(currentLevelLabel)
    }
    
    private func loadMotionManager() {
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    // Challenge 2
    private func prepareForNextLevel() {
        nextLevelLabel.removeFromParent()
        restartLevelLabel.removeFromParent()
        restartGameLabel.removeFromParent()
        
        unloadCurrentLevel()
        loadLevel(currentLevel)
        
        loadPlayer()
        isGameOver = false
    }
    
    private func unloadCurrentLevel() {
        children.forEach { node in
            if ["wall", "vortex", "star", "finish", "portal"].contains(node.name) {
                node.removeFromParent()
            }
        }
        player.removeFromParent()
    }
    
    private func playerCollided(with node: SKNode) {
        switch node.name {
        case "vortex":
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.loadPlayer()
                self?.isGameOver = false
            }
            
        case "star":
            node.removeFromParent()
            score += 1
            
        case "finish":
            player.physicsBody?.isDynamic = false
            addChild(nextLevelLabel)
            addChild(restartLevelLabel)
            addChild(restartGameLabel)
           
        // Challenge 3
        case "portal":
            if isPortalActive {
                // Find exit portal node
                for childrenNode in children {
                    // Avoid exiting to the portal that we are entering
                    if childrenNode.name == "portal" && childrenNode != node {
                        enterPortal(from: node, to: childrenNode)
                        break
                    }
                }
            }
            
        default:
            break
        }
        
        // Challenge 3
        // If the player went to a different collision directly after a portal, didEnd won't be called
        if !isPortalActive && node.name != "portal" {
            isPortalActive = true
        }
    }
    
    // Challenge 3
    func playerEndedCollision(with node: SKNode) {
        guard node.name == "portal" else { return }
        isPortalActive = true
    }
    
    // Challenge 3
    func enterPortal(from inNode: SKNode, to outNode: SKNode) {
        player.physicsBody?.isDynamic = false
        
        let rotate = SKAction.rotate(byAngle: -.pi, duration: 0.1)
        let rotateSequence = SKAction.sequence([rotate, rotate, rotate, rotate, rotate])
        player.run(rotateSequence)
        
        let move = SKAction.move(to: inNode.position, duration: 0.25)
        let fade = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, fade, remove])
        
        player.run(sequence) { [weak self, weak outNode] in
            if let outNode = outNode {
                self?.exitPortal(to: outNode)
            }
        }
    }
    
    // Challenge 3
    func exitPortal(to outNode: SKNode) {
        loadPlayer()
        player.alpha = 0.0
        player.position = outNode.position
        
        let rotate = SKAction.rotate(byAngle: -.pi, duration: 0.05)
        let rotateSequence = SKAction.sequence([rotate, rotate, rotate, rotate, rotate])
        
        player.run(rotateSequence)
        player.run(SKAction.fadeIn(withDuration: 0.25))
        
        isPortalActive = false
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerEndedCollision(with: nodeB)
        } else if nodeB == player {
            playerEndedCollision(with: nodeA)
        }
    }
    
}
