//
//  ViewController.swift
//  InstaFilter
//
//  Created by JC on 9/9/21.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var intensity: UISlider!
    @IBOutlet var imageView: UIImageView!
    // Slider added because of the intructor's challenge
    @IBOutlet var rotation: UISlider!
    @IBOutlet var changeButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        //Challenge of instructor
        changeButton.setTitle(currentFilter.name, for: .normal)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        animate(0)
        currentImage = image
        animate(1)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let filters = [
            "CIBumpDistortion",
            "CIGaussianBlur",
            "CIPixellate",
            "CISepiaTone",
            "CITwirlDistortion",
            "CIVignette",
            "CIUnsharpMask"
        ]
        let alertController = UIAlertController(
            title: "Choose filter",
            message: nil,
            preferredStyle: .actionSheet
        )
        for filter in filters {
            alertController.addAction(UIAlertAction(title: filter, style: .default, handler: setFilter))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Necessary for iPad to havea point of reference for showing the action sheet
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
                                  
        present(alertController, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        // Challenge of instructor
        changeButton.setTitle(actionTitle, for: .normal)
        applyProcessing()
    }
    
    // Button save click listener
    @IBAction func save(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(image(_:didFinishSavingWithError:contextInfo:)),
                nil
            )
        } else {
            // Challenge of the instructor
            showAlertController(
                "Error",
                "There is no image to save. Click the \"add\" button from the upper right corner"
            )
        }
    }
    
    //Slider value changed
    @IBAction func sliderValueChanged(_ sender: Any) {
        applyProcessing()
    }
    
    /**
     Some filters doesn't support the intensity value of the slider, so we need to access its
     inputKeys and to check if it contains compatible keys with the intensity value. It's not
     within a switch statement because some filters use multiple keys.
     */
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
    
        if inputKeys.contains(kCIInputIntensityKey) {
            print("kCIInputIntensityKey")
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            print("kCIInputRadiusKey")
            currentFilter.setValue(rotation.value * 500, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            print("forUndefinedKey")
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            print("kCIInputCenterKey")
            currentFilter.setValue(
                CIVector(
                    x: currentImage.size.width / 2,
                    y: currentImage.size.height / 2
                ),
                forKey: kCIInputCenterKey
            )
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error {
            showAlertController("Save error", error.localizedDescription)
        } else {
            showAlertController("Saved", "Photo successfully edited!")
        }
    }
    
    func showAlertController(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    // Challenge of the instructor (day 58)
    func animate(_ alpha: Int) {
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = CGFloat(alpha)
        })
    }
}

