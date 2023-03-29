//
//  DetailViewController.swift
//  WorldFlags
//
//  Created by JC on 28/3/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var countryName: String!
    var imageFilename: String!
    
    private var areNavigationBarViewsHidden = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTapGestureRecognizer()
        configurePinchGestureRecognizer()
        configurePanGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Methods
    
    private func configureViewController() {
        title = countryName
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        imageView.image = UIImage(named: imageFilename)
        imageView.isUserInteractionEnabled = true
    }
                     
    private func configureTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configurePinchGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        imageView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Actions
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        areNavigationBarViewsHidden.toggle()

        if areNavigationBarViewsHidden {
            // Hide navigation bar items
            navigationController?.navigationBar.subviews.forEach { subview in
                subview.isHidden = true
            }

            // Animate background color change to black
            UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = .black
            })
        } else {
            // Show navigation bar items
            navigationController?.navigationBar.subviews.forEach { subview in
                subview.isHidden = false
            }

            // Animate background color change to white
            UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = .white
            })
        }
    }
    
    @objc private func didTapShare() {
        let viewController = UIActivityViewController(
            activityItems: [imageView.image!],
            applicationActivities: []
        )

        /**
         This line is for iPad, because the activity view controller must be shown from somewhere on
         the screen. In this case, we are telling the view that it will pop up from a bar button item,
         which is the right bar button item.
         */
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        // Same as show()
        present(viewController, animated: true)
    }
    
    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            // Scale the image view by the gesture's scale
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            
            // Limit the minimum scale value
            let minScale: CGFloat = 1.0
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            let newScale = currentScale * sender.scale
            if newScale < minScale {
                sender.scale = minScale / currentScale
                imageView.transform = imageView.transform.scaledBy(
                    x: minScale / currentScale,
                    y: minScale / currentScale
                )
            }
            
            sender.scale = 1.0
        }
    }
    
    /** How to prevent a zoomed in image with pan gesture attached from panning outside the screen’s frame?
     
     @objc private func didPan(_ sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: imageView.superview)
         
         if sender.state == .began || sender.state == .changed {
             let maxX: CGFloat = imageView.image!.size.width
             let minX: CGFloat = 0
             let maxY: CGFloat = imageView.image!.size.height
             let minY: CGFloat = 0
             
             var newCenterX = imageView.center.x + (translation.x)
             var newCenterY = imageView.center.y + translation.y
             
             if newCenterX - translation.x < minX {
                 newCenterX = 0
             }
             
             if newCenterX + translation.x > maxX {
                 newCenterX = maxX
             }
             
             print("newCenterX: \(newCenterX)")
             
             print("translation.x: \(translation.x)")
             print("translation.y: \(translation.y)")
             
             // Update the image view's position based on the gesture's translation
             imageView.center = CGPoint(x: newCenterX, y: newCenterY)
             sender.setTranslation(CGPoint.zero, in: imageView.superview)
         }
     }
     */
    
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: imageView.superview)
        
        if sender.state == .began || sender.state == .changed {
            // Update the image view's position based on the gesture's translation
            imageView.center = CGPoint(
                x: imageView.center.x + translation.x,
                y: imageView.center.y + translation.y
            )
            sender.setTranslation(CGPoint.zero, in: imageView.superview)
        }
    }

}
