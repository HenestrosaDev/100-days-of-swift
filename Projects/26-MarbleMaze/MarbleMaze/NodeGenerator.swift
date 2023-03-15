//
//  NodeGenerator.swift
//  MarbleMaze
//
//  Created by JC on 23/9/21.
//

import SpriteKit

// Challenge 1
class NodeGenerator {
    
    static let instance = NodeGenerator()
    
    func createNode(for nodeName: String, at position: CGPoint) -> SKSpriteNode {
        guard let collisionType = CollisionTypes.withLabel(nodeName) else {
            fatalError("Collision type not found")
        }
        
        let node = SKSpriteNode(imageNamed: nodeName)
        
        // Common config
        node.name = nodeName
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = collisionType.rawValue
        
        nodeCase(type: collisionType, node: node)
        
        return node
    }
    
    func nodeCase(type: CollisionTypes, node: SKSpriteNode) {
        switch type {
        case .wall:
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = false
        case .vortex, .star, .finish, .portal:
            elementNode(node: node)
        case .player:
            playerNode(node: node)
        }
    }
    
    func elementNode(node: SKSpriteNode) {
        if node.name == "vortex" {
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        } else if node.name == "portal" {
            let scale = SKAction.scale(by: 1.07, duration: 1.5)
            node.run(SKAction.repeatForever(SKAction.sequence([scale, scale.reversed()])))
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: -.pi, duration: 6)))
        }
        
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
    }
    
    func playerNode(node: SKSpriteNode) {
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.linearDamping = 0.5
        node.zPosition = 1
        
        node.physicsBody?.contactTestBitMask =
          CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue

        node.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
    }
}
