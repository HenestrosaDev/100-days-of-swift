//
//  NodeGenerator.swift
//  MarbleMaze
//
//  Created by JC on 23/9/21.
//

import SpriteKit

class NodeGenerator {
    
    static let instance = NodeGenerator()
    
    func createNode(for nodeName: String, at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: nodeName)//
        node.name = nodeName
        node.position = position
        
        guard let collisionType = CollisionTypes.withLabel(nodeName) else { fatalError("Collision type not found") }
        
        nodeCase(type: collisionType, node: node)
        
        node.physicsBody?.categoryBitMask = collisionType.rawValue  ///
        
        return node
    }
    
    func nodeCase(type: CollisionTypes, node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        switch type {
        case .wall:
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        case .vortex, .star, .finish:
            elementNode(node: node)
        case .player:
            playerNode(node: node)
        }
        
        if node.name != "player" {
            node.physicsBody?.isDynamic = false //
        }
    }
    
    func elementNode(node: SKSpriteNode) {
        if node.name == "vortex" {
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        }
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
    }
    
    func playerNode(node: SKSpriteNode) {
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.linearDamping = 0.5
        node.zPosition = 1
        
        node.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        node.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
    }
}
