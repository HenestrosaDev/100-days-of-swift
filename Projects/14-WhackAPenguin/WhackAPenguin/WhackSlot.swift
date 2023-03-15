//
//  WhackSlot.swift
//  WhackAPenguin
//
//  Created by JC on 10/9/21.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var isVisible = false
    var isHit = false
    // penguinNode stores the penguin picture node
    var penguinNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        /**
         A crop node uses an image as a cropping mask: Anything in the colored part will be visible,
         anything in the transparent part will be invisible. We need to crop the penguin in order to
         give the impression that they are inside the holes. The mask is shaped like the hole. When
         the penguin moves outside the mask, the penguin will be invisible.
         */
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        penguinNode = SKSpriteNode(imageNamed: "penguinGood")
        penguinNode.position = CGPoint(x: 0, y: -90)
        penguinNode.name = "penguin"
        /**
         We need to add the penguinNode to the cropNode because the cropNode  only crops nodes that
         are inside it. The hierarchy goes like this: Root view -> Slot -> Hole & (Crop -> Penguin)
         */
        cropNode.addChild(penguinNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        penguinNode.xScale = 0.85
        penguinNode.yScale = 0.85
        
        penguinNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.005))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            penguinNode.texture = SKTexture(imageNamed: "penguinGood")
            penguinNode.name = "penguinGood"
        } else {
            penguinNode.texture = SKTexture(imageNamed: "penguinEvil")
            penguinNode.name = "penguinEvil"
        }
        
        /**
         The 3.5 is completely arbitary. The lesser the number, the faster will disappear and allow
         his hole to be vacant.
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        if !isHit {
            addParticle(as: "mud", at: penguinNode.position)
        }
        penguinNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {
            [weak self] in
            self?.isVisible = false
        }
        
        addParticle(as: "smoke", at: penguinNode.position)
        let sequence = SKAction.sequence([delay, hide, notVisible])
        penguinNode.run(sequence)
    }
    
    func addParticle(as type: String, at position: CGPoint) {
        var emitter: SKEmitterNode?
        
        if type == "mud" {
            emitter = SKEmitterNode(fileNamed: "mud") ?? nil
        } else {
            emitter = SKEmitterNode(fileNamed: "smoke") ?? nil
        }
        
        guard let validEmitter = emitter else { return }

        validEmitter.position = position
        let addEmitterAction = SKAction.run {
            [weak self] in
            self?.addChild(validEmitter)
        }
        let emitterDuration = CGFloat(0.5/*validEmitter.numParticlesToEmit*/) * validEmitter.particleLifetime
        let wait = SKAction.wait(forDuration: TimeInterval(emitterDuration))
        let remove = SKAction.run({validEmitter.removeFromParent()})
        let sequence = SKAction.sequence([addEmitterAction, wait, remove])
        
        self.run(sequence)
    }
}
