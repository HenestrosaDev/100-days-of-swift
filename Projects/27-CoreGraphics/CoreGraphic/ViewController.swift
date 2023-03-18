//
//  ViewController.swift
//  CoreGraphic
//
//  Created by JC on 16/3/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentDrawType = 0
    let canvasWidth: CGFloat = 512
    let canvasHeight: CGFloat = 512
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }

    // MARK: - Private Methods
    
    @IBAction private func didTapRedraw(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        // Challenge 1
        case 6:
            drawStarEmoji()
                
        // Challenge 2
        case 7:
            drawTwinText()
            
        default:
            break
        }
    }
    
    private func drawRectangle() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        // instead of image(), we can also use pngData() and jpegData() to get back a Data object
        let image = renderer.image { ctx in
            // ctx is the canvas in which we can draw
            let rectangle = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight)
                .insetBy(dx: 26, dy: 26)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // Draws 5 points inside the rectangle and 5 points outside of it
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    private func drawCircle() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        // instead of image(), we can also use pngData() and jpegData() to get back a Data object
        let image = renderer.image { ctx in
            // insetBy() lets us push each edge by a certain amount
            let rectangle = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight)
                .insetBy(dx: 26, dy: 26)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // Draws 5 points inside the rectangle and 5 points outside of it
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    private func drawCheckerboard() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        // canvasWidth / 8 because a checkboard has 8 rows
        let tileSize: Int = Int(canvasWidth / 8)
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        // fill() skips the addPath() drawPath() work
                        // fills the rectangle using whatever the current color is
                        ctx.cgContext.fill(
                            CGRect(
                                x: col * tileSize,
                                y: row * tileSize,
                                width: tileSize,
                                height: tileSize
                            )
                        )
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    private func drawRotatedSquares() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let image = renderer.image { ctx in
            // Changes the origin of the user coordinate system in a context
            ctx.cgContext.translateBy(x: canvasWidth / 2, y: canvasHeight / 2)
            
            let rotations = 16
            let rotationAmount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                // Rotates the current transformation matrix
                ctx.cgContext.rotate(by: CGFloat(rotationAmount))
                ctx.cgContext.addRect(
                    CGRect(
                        x: -(canvasWidth / 4),
                        y: -(canvasHeight / 4),
                        width: canvasWidth / 2,
                        height: canvasHeight / 2)
                )
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            // Strokes the path with your specified line width (1 by default)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    private func drawLines() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let image = renderer.image { ctx in
            // Moves the current transformation matrix to the coordinates
            ctx.cgContext.translateBy(x: canvasWidth / 2, y: canvasHeight / 2)
            
            var first = true
            var length: CGFloat = canvasWidth / 2
            
            for _ in 0 ..< (Int(canvasWidth) / 2) {
                ctx.cgContext.rotate(by: .pi / 2)
                
                /**
                 move() and addLine(to:) are CoreGraphics equivalents to the UIBezierPath
                 (used in project 20). They are useful for drawing lines.
                 */
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    private func drawImagesAndText() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let image = renderer.image { ctx in
            // Defines a paragraph style that aligns text to the center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // Creates an attributes dictionary containing the paragraph and font style
            let attrs: [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 36),
                .paragraphStyle : paragraphStyle
            ]
            
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            /**
             Draws the attributed string to the canvas using the line fragment origin instead of
             the baseline origin.
             */
            attributedString.draw(
                with: CGRect(x: 32, y: 32, width: canvasWidth * 0.88, height: canvasHeight * 0.88),
                options: .usesLineFragmentOrigin,
                context: nil
            )
            
            // Loads an image from the project and draws it to the context
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: canvasWidth * 0.59, y: canvasHeight * 0.30))
        }
        
        // Update the image view with the finished result
        imageView.image = image
    }
    
    // Challenge 1
    private func drawStarEmoji() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let image = renderer.image { ctx in
            // HALF-LEFT OF THE STAR
            // Move to the starting point of the line (x: centerX, y: close to the top)
            ctx.cgContext.move(to: CGPoint(x: canvasWidth / 2, y: 30))
            
            // Add lines to the ending point of each line
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 - 68, y: 210))
            ctx.cgContext.addLine(to: CGPoint(x: 3, y: 210))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 - 101, y: 305))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 - 146, y: canvasHeight - 30))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2, y: 380))
            
            // ------------------------------------------------------------------------
            
            // HALF-RIGHT OF THE STAR
            // Move to the starting point of the line (x: centerX, y: close to the top)
            ctx.cgContext.move(to: CGPoint(x: canvasWidth / 2, y: 30))
            
            // Add lines to the ending point of each line
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 + 68, y: 210))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth - 3, y: 210))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 + 101, y: 305))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2 + 146, y: canvasHeight - 30))
            ctx.cgContext.addLine(to: CGPoint(x: canvasWidth / 2, y: 380))
            
            // ------------------------------------------------------------------------
            
            // Set the line and fill color along with the width
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(6.0)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineJoin(.round)
            
            // Draw the lines
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        // Update the image view with the finished result
        imageView.image = image
    }
    
    
    // Challenge 2
    private func drawTwinText() {
        // UIGraphicsImageRenderer is a gateway from UIKit to CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let image = renderer.image { ctx in
            let maxHeight: CGFloat = canvasHeight / 2 - 40
            let baseHeight: CGFloat = canvasHeight / 2 + 40
            let spaceBetweenLetters: CGFloat = 40
            
            // Letter T
            let leadingAnchorLetterT: CGFloat = 60
            let trailingAnchorLetterT: CGFloat = leadingAnchorLetterT + 80
            let centerXLetterT = (trailingAnchorLetterT - leadingAnchorLetterT) / 2 + leadingAnchorLetterT
            
            ctx.cgContext.move(to: CGPoint(x: centerXLetterT, y: baseHeight))
            
            ctx.cgContext.addLine(to: CGPoint(x: centerXLetterT, y: maxHeight))
            ctx.cgContext.addLine(to: CGPoint(x: leadingAnchorLetterT, y: maxHeight))
            ctx.cgContext.addLine(to: CGPoint(x: trailingAnchorLetterT, y: maxHeight))
            
            // Letter W
            let leadingAnchorLetterW: CGFloat = trailingAnchorLetterT + spaceBetweenLetters
            let trailingAnchorLetterW: CGFloat = leadingAnchorLetterW + 70
            
            ctx.cgContext.move(to: CGPoint(x: leadingAnchorLetterW, y: maxHeight)) // 175
            
            ctx.cgContext.addLine(to: CGPoint(x: leadingAnchorLetterW + 25, y: baseHeight))
            ctx.cgContext.addLine(
                to: CGPoint(x: leadingAnchorLetterW + 35, y: (maxHeight - baseHeight) / 2 + baseHeight)
            )
            ctx.cgContext.addLine(to: CGPoint(x: leadingAnchorLetterW + 45, y: baseHeight))
            ctx.cgContext.addLine(to: CGPoint(x: leadingAnchorLetterW + 70, y: maxHeight))
            
            // Letter I
            let leadingAnchorLetterI: CGFloat = trailingAnchorLetterW + spaceBetweenLetters
            let trailingAnchorLetterI: CGFloat = leadingAnchorLetterI + 15
            let centerXLetterI = (trailingAnchorLetterI - leadingAnchorLetterI) / 2 + leadingAnchorLetterI
            
            ctx.cgContext.move(to: CGPoint(x: leadingAnchorLetterI, y: baseHeight))
            ctx.cgContext.addLine(to: CGPoint(x: trailingAnchorLetterI, y: baseHeight))
            
            ctx.cgContext.move(to: CGPoint(x: centerXLetterI, y: baseHeight))
            ctx.cgContext.addLine(to: CGPoint(x: centerXLetterI, y: maxHeight))
            
            ctx.cgContext.move(to: CGPoint(x: leadingAnchorLetterI, y: maxHeight))
            ctx.cgContext.addLine(to: CGPoint(x: trailingAnchorLetterI, y: maxHeight))
            
            // Letter N
            let leadingAnchorLetterN: CGFloat = trailingAnchorLetterI + spaceBetweenLetters
            let trailingAnchorLetterN: CGFloat = leadingAnchorLetterN + 60
            
            ctx.cgContext.move(to: CGPoint(x: leadingAnchorLetterN, y: baseHeight))
            
            ctx.cgContext.addLine(to: CGPoint(x: leadingAnchorLetterN, y: maxHeight))
            ctx.cgContext.addLine(to: CGPoint(x: trailingAnchorLetterN, y: baseHeight))
            ctx.cgContext.addLine(to: CGPoint(x: trailingAnchorLetterN, y: maxHeight))
            
            // ------------------------------------------------------------------------
            
            // Set the line and fill color along with the width
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10.0)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineJoin(.round)
            
            // Draw the lines
            ctx.cgContext.strokePath()
        }
        
        // Update the image view with the finished result
        imageView.image = image
    }
    
}

