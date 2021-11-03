//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by JC on 18/9/21.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    // They are both useful because they blend the color together
    var activeSliceBackground: SKShapeNode!
    var activeSliceForeground: SKShapeNode!
    //
    var activeSlicePoints = [CGPoint]()
    var activeEnemies = [SKSpriteNode]()
    
    var isSwooshSoundActive = false
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9 // Waiting time between last enemy destroyed and a new one created
    var sequence = [SequenceType]()
    var sequencePosition = 0 // Where we are right now in the game
    var chainDelay = 3.0 // How long to wait before creating a new enemy when te sequence type is .chain or .fastChain
    var nextSequenceQueued = true // Allows us to know when all the enemies are destroyed and we're ready to create more
    
    var isGameEnded = false
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        // Starting sequence of the game
        sequence = [.one, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBackground.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceForeground.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        // Removes the SKAction.fadeOut created in touchesBegan
        activeSliceBackground.removeAllActions()
        activeSliceForeground.removeAllActions()
        
        // Makes the future slices visible again because removeAllActions sets the alpha to 0
        activeSliceBackground.alpha = 1
        activeSliceForeground.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if let name = node.name {
                if name.contains("penguin") {
                    if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                        emitter.position = node.position
                        addChild(emitter)
                    }

                    // Challenge 2 of instructor
                    if node.name == "penguin" {
                        score += 1
                    } else {
                        score += 5
                    }
                    
                    node.name = ""
                    node.physicsBody?.isDynamic = false
                    node.run(loadAnimations())
                    
                    if let index = activeEnemies.firstIndex(of: node) {
                        activeEnemies.remove(at: index)
                    }
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                    
                } else if node.name == "bomb" {
                    guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                    
                    if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                        emitter.position = bombContainer.position
                        addChild(emitter)
                    }
                    
                    node.name = ""
                    bombContainer.physicsBody?.isDynamic = false
                    bombContainer.run(loadAnimations())
                    
                    if let index = activeEnemies.firstIndex(of: bombContainer) {
                        activeEnemies.remove(at: index)
                    }
                    
                    run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                    endGame(triggeredByBomb: true)
                }
            }
        }
    }
    
    func loadAnimations() -> SKAction {
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        return SKAction.sequence([group, .removeFromParent()])
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return } // same as: if gameEnded { return }
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            for i in 0...2 {
                livesImages[i].texture = SKTexture(imageNamed: "sliceLifeGone")
            }
        }
        
        gameOver() // Challenge 3 of instructor
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if let name = node.name {
                        if name.contains("penguin") {
                            subtractLife()
                        }
                    }
                    
                    node.name = ""
                    node.removeFromParent()
                    activeEnemies.remove(at: index)
                }
            }
        } else {
            // If there is no sequence in the queue, we create a new one
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) {
                    [weak self] in
                    self?.tossEnemies()
                }
                
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        // If there are no bombs on the GameScene, stop the bomb sound and destroy it.
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { // When the .caf file finishes, then a new swoosh sound will be played
            [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBackground = SKShapeNode()
        activeSliceBackground.zPosition = 2
        
        activeSliceForeground = SKShapeNode()
        activeSliceForeground.zPosition = 3
        
        activeSliceBackground.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBackground.lineWidth = 9
        
        activeSliceForeground.strokeColor = .white
        activeSliceForeground.lineWidth = 5
        
        addChild(activeSliceForeground)
        addChild(activeSliceBackground)
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBackground.path = nil
            activeSliceForeground.path = nil
            return
        }
        
        // Removes the oldest slice in order to keep the screen clean
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBackground.path = path.cgPath
        activeSliceForeground.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random, isFastEnemy: Bool = false) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // If the bomb fuse sound is playing, stop it and destroy it.
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            // Creates a new bomb fuse sound effect
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            // Adds the fuse emitter at the tip of the wick
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            
            // Challenge 2 of instructor
            if isFastEnemy {
                enemy.colorBlendFactor = 0.5
                enemy.color = .cyan
                enemy.name = "penguinFast"
            } else {
                enemy.name = "penguin"
            }
        }
        
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        
        if !isFastEnemy {
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        } else {
            // Challenge 2 of instructorf
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 60, dy: randomYVelocity * 60)
        }
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func tossEnemies() {
        guard isGameEnded == false else { return }
        
        popupTime *= 0.991
        chainDelay *= 0.991
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            print(".oneNoBomb")
            createEnemy(forceBomb: .never)
            
        case .one:
            print(".one")
            createEnemy()
            
        case .twoWithOneBomb:
            print(".twoWithOneBomb")
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            print(".two")
            createEnemies(iterations: 2)
            
        case .three:
            print(".three")
            createEnemies(iterations: 3)
            
        case .four:
            print(".four")
            createEnemies(iterations: 4)
            
        case .chain:
            print(".chain")
            createChain(delay: 5.0)
            
        case .fastChain:
            print(".fastChain")
            createChain(delay: 10.0)
            
        // Challenge 2 if instructor
        case .fastEnemy:
            createEnemy(forceBomb: .never, isFastEnemy: true)
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    func createEnemies(iterations: Int) {
        for _ in 1...iterations {
            createEnemy()
        }
    }
    
    func createChain(delay: Double) {
        createEnemy()
        
        for i in 1...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / delay * Double(i))) { [weak self] in self?.createEnemy() }
        }
    }
    
    // Challenge 3 of instructor
    func gameOver() {
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
    }
    
}
