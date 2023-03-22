//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by JC on 20/3/23.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: Public Properties
    
    /**
     Necessary for communicating the user interface's value changes to the GameScene.
     The GameViewController strongly owns the game scene indirectly (it owns the SKView), so we
     need to add a weak reference to access the ViewController in order to avoid a strong reference
     cycle, where neither object can be destroyed.
     */
    weak var viewController: GameViewController?
    
    // MARK: Private Properties
    
    private var buildings = [BuildingNode]()
    private lazy var player1 = SKSpriteNode(imageNamed: "player")
    private lazy var player2 = SKSpriteNode(imageNamed: "player")
    private var banana: SKSpriteNode!
    
    private var currentPlayer = 1
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        // Night sky background color
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        physicsWorld.contactDelegate = self
        
        createBuildings()
        create(player: player1, number: 1)
        create(player: player2, number: 2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    // MARK: Public Methods
    
    func launchBanana(angle: Int, velocity: Int) {
        // Challenge 3
        if let gravity = viewController?.wind.getGravity(player: currentPlayer) {
            physicsWorld.gravity = gravity
        }
        
        let speed = Double(velocity) / 10.0
        
        let radians = angle.toRadians()
        
        // Remove the banana, if there's already one.
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = NodeNames.banana.rawValue
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue
        
        /**
         SpriteKit uses a number of optimizations to help its physics simulation work at high speed
         These optimizations don't work well with small, fast-moving objects, so we need to set the
         usesPreciseCollisionDetection property to true in order ro make sure that everything works
         as intended.
         */
        banana.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(banana)
        
        let player = currentPlayer == 1 ? player1 : player2
        
        /**
         Simplifies the code for setting the impulse vector, instead of duplicating the entire line
         of code with a sign change. If it's player2, which is on the right, the impulse must be
         negative, which makes the banana go to the left.
         */
        let impulseMultiplier: CGFloat = currentPlayer == 1 ? 1 : -1

        banana.position = CGPoint(
            x: player.position.x + (30 * impulseMultiplier),
            y: player.position.y + 40
        )
        banana.physicsBody?.angularVelocity = 20 * impulseMultiplier

        // Animates the player throwing their arm up then putting it down again.
        let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player\(currentPlayer)Throw"))
        let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
        let pause = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
        player.run(sequence)

        // Makes the banana move in the right direction
        let impulse = CGVector(
            dx: cos(radians) * speed * impulseMultiplier,
            dy: sin(radians) * speed
        )
        
        // Makes the banana actually move
        banana.physicsBody?.applyImpulse(impulse)
    }
    
    // Challenge 1
    func newGame() {
        // To transition from one scene to another, we need to create the scene
        let newGame = GameScene(size: size)
        
        /**
         We need to update the `currentGame` property and the `viewController` property so they can
         talk to each other once the change has happened.
         */
        newGame.viewController = viewController
        viewController?.currentGame = newGame
        
        changePlayer()
        
        /**
         New game's `currentPlayer` property must be set to our own `currentPlayer` property, so
         that whoever died gets the first shot.
         */
        newGame.currentPlayer = currentPlayer
        
        // Create a transition to navigate to the new scene
        let transition = SKTransition.doorway(withDuration: 1.5)
        
        // Present the scene with the transition
        self.view?.presentScene(newGame, transition: transition)
    }
    
    // MARK: Private Methods
    
    private func createBuildings() {
        /**
         Start at -15 rather than 0 so that the buildings look like they keep on going past the
         screen's edge.
         */
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            /**
             The width divides evenly into 40 so the window-drawing code works as expected.
             The possible generated heights are 80, 120 and 160.
             */
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            
            /**
             +2 to leave a 2-point gap between the buildings to distinguish their edges slightly
             more.
             */
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    private func create(player: SKSpriteNode, number: Int) {
        player.name = "player\(number)"
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player.physicsBody?.isDynamic = false
        
        let playerBuildingIndex = number == 1 ? 1 : buildings.count - 2
        let playerBuilding = buildings[playerBuildingIndex]
        
        player.position = CGPoint(
            x: playerBuilding.position.x,
            y: playerBuilding.position.y + ((playerBuilding.size.height + player.size.height) / 2)
        )
        
        addChild(player)
    }
    
    private func bananaHit(player: SKNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        // Challenge 1
        viewController?.playerScored(playerNumber: self.currentPlayer)
        
        if viewController?.isGameFinished == false { // Challenge 1
            /**
             The code inside will get executed 2 seconds after the banana hits a player in order
             to let the players see who won.
             */
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.newGame()
            }
        }
    }
    
    private func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        
        /**
         Asks the game scene to convert the collision contact point into the coordinates relative
         to the building node. That is, if the building node was at X:200 and the collision was
         at X:250, this would return X:50, because it was 50 points into the building node.
         */
        let buildingLocation = convert(contactPoint, to: building)
        
        building.hit(at: buildingLocation)
        
        // Add explosion at the position in which the banana hit the building
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        // Remove the banana from the scene
        
        /**
         This is needed because if a banana hits two buildings at the same time, then it will
         explode twice and thus call changePlayer() twice. By clearing the name, the second
         collision won't happen because our didBegin() method won't see the banana as being a
         banana any more because the node doesn't have a name.
         */
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        // Change players turn
        changePlayer()
    }
    
    /**
     Transfers control of the game to the other player.
     */
    private func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        viewController?.activatePlayer(number: currentPlayer)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        /**
         We assign to the first body the physics body with the lowest number. Bear in mind that we
         want the banana to be the first body in order to simplify the checks done down below to
         know on which node has the banana impacted.
         */
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Safely unwrap the second node and check if the firstBody name is actually "banana"
        guard firstBody.node?.name == NodeNames.banana.rawValue, let secondNode = secondBody.node else {
            return
        }
        
        // Depending on which node has the banana impacted on, we'll call a different method
        switch secondNode.name {
        case NodeNames.building.rawValue:
                bananaHit(building: secondNode, atPoint: contact.contactPoint)
                
        case NodeNames.player1.rawValue:
            bananaHit(player: player1)
                
        case NodeNames.player2.rawValue:
            bananaHit(player: player2)
            
        default:
            break
        }
    }
    
}
