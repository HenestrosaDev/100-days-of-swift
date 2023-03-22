//
//  BuildingNode.swift
//  ExplodingMonkeys
//
//  Created by JC on 20/3/23.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {

    // MARK: Private Properties
    
    private var currentImage: UIImage!
    
    // MARK: - Initializers
    
    /**
     In the course, Paul created a setup() method instead of using a class initializer to
     initialize the node. The argument that he gives for using the setup() method insead of an
     initializer is the following: "This is using the the same 'don't override the initializer'
     hack from project 14, because quite frankly if I wanted to explain to you how and why Swift's
     initialization system worked I'd probably have to add another whole book to this series!"
     I think that's a wack argument, especially for a course, because you're not explaining why
     you don't the default class method for setting up the initial values of a class' object.
     
     As you can see here, I've used an initializer instead of the setup() method to avoid hacky
     code.
     */
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        
        name = NodeNames.building.rawValue
        
        currentImage = drawBuilding(size: size)
        
        // Converts the not-damaged building image into the node's texture
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func hit(at point: CGPoint) {
        /**
         Figure out where the building was hit. Remember: SpriteKit's positions things from the
         center and Core Graphics from the top left corner.
         */
        let convertedPoint = CGPoint(
            x: point.x + size.width / 2.0,
            y: abs(point.y - (size.height / 2.0))
        )
        
        // Create a new CoreGraphics context the size of the current sprite
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            currentImage.draw(at: .zero)
            
            /**
             Create an ellipse at the collision point. The exact co-ordinates will be 32 points
             up and to the left of the collision, then 64x64 in size - an ellipse centered on the
             impact point.
             */
            ctx.cgContext.addEllipse(
                in: CGRect(
                    x: convertedPoint.x - 32,
                    y: convertedPoint.y - 32,
                    width: 64,
                    height: 64
                )
            )
            
            // .clear will cut an ellipse out of the building image
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        // Update the building's texture and image
        texture = SKTexture(image: img)
        currentImage = img
        
        // Recalculate the per-pixel physics for our damaged building
        configurePhysics()
    }
    
    // MARK: Private Methods
    
    /**
     Set ups per-pixel physics for the sprite's current texture
     */
    private func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    /**
     Core Graphics rendering of a building. Returns an UIImage.
     */
    private func drawBuilding(size: CGSize) -> UIImage {
        // Creates a new CoreGraphics context the size of our building
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            // Fill it with a rectangle that's one of three colors
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let color: UIColor
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
                
            case 1:
                color = UIColor(hue: 0.99, saturation: 0.99, brightness: 0.67, alpha: 1)
                
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            
            // Draw windows all over the building in one of two colors (yellow if on, gray if off)
            let lightOnColor = UIColor(hue: 0.19, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            /**
             - stride() is similar to a C `for` loop
             - It has two variants: stride(from:to:by:), which counts up to but excluding the `to`
                parameter. The other variant is stride(from:through:by:), which counts up to and
                including the `through` parameter.
             */
            for row in stride(from: 10, through: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, through: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
        }
        
        return img
    }
    
}
