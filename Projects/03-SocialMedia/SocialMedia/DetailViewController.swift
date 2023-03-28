//
//  DetailViewController.swift
//  SocialMedia
//
//  Created by JC on 23/8/21.
//

import UIKit

/**
 This class will manage the visualization of the file (item) selected from the UITable
 */
class DetailViewController: UIViewController {

    // The annotation indicates that this property connected to a view
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var position: Int?
    var totalImages: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(position!) of \(totalImages!)"
        navigationItem.largeTitleDisplayMode = .never
        
        /**
         - barButtonSystemItem displays a different icon depending on the behaviour that we want.
         - action parameter is like saying "when the button is tapped, call the method shareTapped".
         - The target parameter indicates where will the event be displayed.
         - #selector tells the Swift compiler that a method called shareTapped will exist and that it
         will be triggered when the button is tapped.
         */
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    // Same as onStart()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    // Same as onPause()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    /**
     @objc is a compiler attribute that tells Swift to compile the method for Swift use and for
     Objective-C use because UIBarButtomItem is written in Objective-C and doesn't understand
     this method written in Swift.
     */
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        // Challenge (Day 89)
        let canvasWidth: CGFloat = image.size.width
        let canvasHeight: CGFloat = image.size.height
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasWidth, height: canvasHeight))
        
        let coreGraphicsImage = renderer.image { ctx in
            // Draws the image
            image.draw(at: CGPoint(x: 0, y: 0))
                        
            let string = "From Storm Viewer"
            let attrs: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 38)]
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(
                with: CGRect(x: 28, y: 28, width: canvasWidth, height: canvasHeight),
                options: .usesLineFragmentOrigin,
                context: nil
            )
        }
        // End of challenge (day 89)

        // activityItems is the data to be shared. selectedItem! will set the name of the file in the
        // sharing pop up, as requested by the challenge of the instructor.
        let viewController = UIActivityViewController(
            activityItems: [coreGraphicsImage],
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
}
