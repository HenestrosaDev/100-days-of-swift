//
//  ImageViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: Public Properties
    
    // BEFORE:
	// var owner: SelectionViewController!
    
    // AFTER: Add weak in order to avoid a strong reference to the view controller that created it
    weak var owner: SelectionViewController!
    
	var imageName: String!
    
    // MARK: Private Properties
    
	private var animTimer: Timer!
	private var imageView: UIImageView!

    // MARK: - Lifecycle
    
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.black

		// Creates an image view that fills the screen
		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.alpha = 0

		view.addSubview(imageView)

		// Makes the image view fill the screen
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

		// Schedules an animation that does something vaguely interesting
		animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
			// Do something exciting with our image
			self.imageView.transform = CGAffineTransform.identity

			UIView.animate(withDuration: 3) {
				self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

		title = imageName.replacingOccurrences(of: "-Large.jpg", with: "")
        
        /**
         BEFORE:
         
         When creating a UIImage using UIImage(named:), iOS loads the image and puts it into an
         image cache for reuse later. This is useful in case that we know the image will be used
         again. However, if it's unlikely to be reused again (or quite large, like in this case),
         then don't bother putting it into the cache.
         
         let original = UIImage(named: image)!
         */
        
        /**
         AFTER:
         
         This way, we can skip the image cache by specifying an exact path to an image rather than
         just its filename in the app bundle.
         */
        // Challenge 1 (remove all the force unwraps)
        guard let path = Bundle.main.path(forResource: imageName, ofType: nil),
            let originalImage = UIImage(contentsOfFile: path)
        else {
            showAlert(title: "Error", message: "There was an error while getting the image")
            return
        }
        //
        
        /**
         This doesn't really round off the image. This code was in the original project.
         
		 let renderer = UIGraphicsImageRenderer(size: originalImage.size)

		 let roundedImage = renderer.image { ctx in
		 	ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: originalImage.size))
		 	ctx.cgContext.closePath()

             originalImage.draw(at: CGPoint.zero)
		 }
         */

		imageView.image = originalImage
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		imageView.alpha = 0

		UIView.animate(withDuration: 3) { [unowned self] in
			self.imageView.alpha = 1
		}
	}
    
    /**
     REFACTORING:
     
     Needed to avoid a strong reference cycle with SelectionViewController because the timer needs
     to be destroyed if the ImageViewController gets destroyed.
     
     This can also be fixed by putting a [weak self] reference in the schedulerTimer closure.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animTimer.invalidate()
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let imageKey = imageName.replacingOccurrences(of: "-Large.jpg", with: "-Thumb.jpg")
		let defaults = UserDefaults.standard
        
		var currentVal = defaults.integer(forKey: imageKey)
		currentVal += 1

		defaults.set(currentVal, forKey: imageKey)

		// Tell the parent view controller that it should refresh its table counters when we go back
		owner.shouldRefresh = true
	}
}
