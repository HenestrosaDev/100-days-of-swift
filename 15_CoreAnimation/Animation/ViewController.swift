//
//  ViewController.swift
//  Animation
//
//  Created by JC on 11/9/21.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentAnimation = 0
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: width/2, y: height/2)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        //We don't have to type [weak self] because it's impossible for the closures to hold a strong reference to self
        
        //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        //This will make the imageViw to bounce when finishing the animation
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                //Zooms the image. The ratio of X & Y scale should be 1/1 in order to avoid stretching the image
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                //Clears the view of any pre-defined transform, resetting any changes that have been applied by modifying its transform property
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -(self.width/3), y: -(self.height/3))
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

