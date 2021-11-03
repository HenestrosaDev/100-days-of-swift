//
//  DetailViewController.swift
//  StormViewer
//
//  Created by JC on 23/8/21.
//

import UIKit

/**
 This class will manage the visualization of the file (item) selected from the UITable
 */
class DetailViewController: UIViewController {

    //The annotation says that this is connected to something in Interface Builder
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var position: Int?
    var totalImages: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(position!) of \(totalImages!)"
        navigationItem.largeTitleDisplayMode = .never
        
        //barButtonSystemItem displays a different icon depending on the behaviour that we want. action parameter is like saying "when the button is tapped, call the method shareTapped. The target parameter indicates where will the event be displayed. The #selector tells the Swift compiler that a method called shareTapped will exist and that it will be triggered when the button is tapped
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    // equals onStart()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    // equals onPause()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //@objc is a compiler attribute that tells Swift to compile the method for Swift use and for Objective-C use because UIBarButtomItem is written in Objective-C and doesn't understand this method written in Swift.
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        //activityItems is the data to be shared. selectedItem! will set the name of the file in the sharing pop up, as requested by the challenge of the instructor.
        let viewController = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        //This line is for iPad, because the activity view controller must be shown from somewhere on the screen. In this case, we are telling the view that it will pop up from a bar button item, which is the right bar button item
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        //Equivalent to show()
        present(viewController, animated: true)
    }
}
