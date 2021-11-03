//
//  GameScene.swift
//  MarbleMaze
//
//  Created by JC on 22/9/21.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    
    override func didMove(to view: SKView) {
        addBackground()
        addScore()
        loadLevel()
        loadPlayer()
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { saveLastTouch(touch: touch) }
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
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelometerData.acceleration.y * -50, dy: accelometerData.acceleration.x * 50)
        }
        #endif // Back to normal code again
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else { fatalError("Could not find level1 in the app bundle") }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not load level1 from the app bundle") }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                // 64 because each square in the game world occupies 64x64, so we can find its position by multiplying its row and column by 64. We need to add 32 to the X & Y because SpriteKit calculates its positions from the center of objects.
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                switch letter {
                case "x":
                    addChild(nodeGen.createNode(for: "wall", at: position))
                case "v":
                    addChild(nodeGen.createNode(for: "vortex", at: position))
                case "s":
                    addChild(nodeGen.createNode(for: "star", at: position))
                case "f":
                    addChild(nodeGen.createNode(for: "finish", at: position))
                case " ":
                    continue
                default:
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func loadPlayer() {
        player = nodeGen.createNode(for: "player", at: CGPoint(x: 96, y: 672))
        addChild(player)
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    func loadMotionManager() {
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
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
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            
        }
    }
}
