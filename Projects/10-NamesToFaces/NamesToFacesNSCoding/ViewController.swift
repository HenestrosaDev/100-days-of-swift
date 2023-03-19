//
//  ViewController.swift
//  NamesToFaces
//
//  Created by JC on 2/9/21.
//

import UIKit
import LocalAuthentication

/**
 UINavigationControllerDelegate is needed because of the delegate above. This one has two optional
 methods to implement which are not necessary in this case.
 */
class ViewController: UICollectionViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var people = [Person]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Day 93 challenge
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Unlock",
            style: .plain,
            target: self,
            action: #selector(insertBiometricAuthentication)
        )
    }
    
    // MARK: - Overriden Methods
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return people.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // Returns a general table view cell, so we need to typecast it
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Person", for: indexPath
        ) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7 //general item
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        showOptions(person: people[indexPath.item], indexPath: indexPath)
    }

    // MARK: - Private Methods
    
    // Day 93 challenge
    private func unlockApp() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
        navigationItem.rightBarButtonItem = nil
        
        loadImages()
    }
    
    private func loadImages() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople)
                as? [Person] {
                people = decodedPeople
            }
        }
        
        collectionView.reloadData()
    }
    
    // Day 93 challenge
    @objc private func insertBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        /**
         &error => LocalAuthentication framework uses Objective-C (that's why the type of the
         error variable is NSError). We pass the error argument as a reference to our error
         variable, which then changes its value inside the canEvaluatePolicy() method. It's similar
         to inout parameters in Swift.
         */
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "To access sensible content, you must identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if success {
                        self.unlockApp()
                    }
                }
            }
        } else {
            let ac = UIAlertController(
                title: "Biometry unavailable",
                message: "Your device is not configured for biometric authentication",
                preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func showOptions(person: Person, indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: person.name,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            let alertController = UIAlertController(
                title: "Rename person",
                message: nil,
                preferredStyle: .alert
            )
            alertController.addTextField()
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak alertController] _ in
                guard let newName = alertController?.textFields?[0].text else { return }
                person.name = newName
                self?.save()
                self?.collectionView.reloadData()
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alertController, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.collectionView.deleteItems(at: [indexPath])
            self?.people.remove(at: indexPath.row)
        })
                    
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alertController, animated: true)
    }
    
    @objc private func addNewPerson() {
        let picker = UIImagePickerController()
        
        // Allows you to crop the image when selecting it, among other things
        picker.allowsEditing = true
        
        // Conforming to the protocol
        picker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
        } // else: will take the photo from the gallery
        
        present(picker, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        // in: adds that we want the path to be relative to the user's home directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        // This line converts our array into a Data object
        if let saveData = try? NSKeyedArchiver.archivedData(
            withRootObject: people,
            requiringSecureCoding: false
        ) {
            // Saving the Data object into the UserDefaults
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
        }
    }
    
}

// UIImagePickerControllerDelegate tells us when the user chooses an image or cancels the picker
extension ViewController: UIImagePickerControllerDelegate {
    
    /**
     Returns when the user selected an image and it's being returned to you. This method needs to
     do several things:
    
     Extract the image from the dictionary that is passed as a parameter.
     Generate a unique filename for it.
     Convert it to a JPEG, then write that JPEG to disk.
     Dismiss the view controller.
     */
    
    /**
     This dictionary parameter will contain one of two keys: .editedImage (the image that was edited)
     or .originalImage, but in our case it should only ever be the former unless you change the
     allowsEditing property.
     */
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        /**
         All apps that are installed have a directory called Documents where you can save private
         information for the app, and it's also automatically synchronized with iCloud
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
}
