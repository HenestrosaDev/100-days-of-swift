//
//  DetailViewController.swift
//  PhotoCaptions
//
//  Created by JC on 5/4/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photos = [Photo]()
    var selectedPhoto: Photo!
    var selectedPhotoIndex: Int!
    
    private var areNavigationBarViewsHidden = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureImageView()
        
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
        title = selectedPhoto.caption
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(didTapCaption)
        )
    }
    
    private func configureImageView() {
        let photoPath = getDocumentsDirectory().appendingPathComponent(selectedPhoto.fileName)
        imageView.image = UIImage(contentsOfFile: photoPath.path)
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

        let color: UIColor = areNavigationBarViewsHidden ? .black : .white
        
        // Toggle navigation bar items visibility
        navigationController?.navigationBar.subviews.forEach { subview in
            subview.isHidden = areNavigationBarViewsHidden
        }

        // Animate background color change to black
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.view.backgroundColor = color
        })
    }
    
    @objc private func didTapCaption() {
        let ac = UIAlertController(
            title: "Caption",
            message: nil,
            preferredStyle: .alert
        )
        ac.addTextField()
        ac.textFields?[0].text = selectedPhoto.caption
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            
            guard let self = self, let caption = ac?.textFields?[0].text else { return }
            self.selectedPhoto.caption = caption
            self.title = caption
            self.photos[self.selectedPhotoIndex] = self.selectedPhoto
            UserDefaultsManager.save(self.photos, forKey: .photos)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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
