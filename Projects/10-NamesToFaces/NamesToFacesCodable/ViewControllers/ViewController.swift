//
//  ViewController.swift
//  NamesToFaces
//
//  Created by JC on 2/9/21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    // MARK: Properties
    
    private var people = [Person]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }

    // MARK: - Methods
    
    private func configureViewController() {
        // Day 93 challenge
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Unlock",
            style: .plain,
            target: self,
            action: #selector(didTapUnlock)
        )
    }
    
    @objc private func didTapUnlock() {
        BiometricManager.insertBiometricAuthentication { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.unlockApp()
            } else {
                let ac = UIAlertController(
                    title: "Biometry unavailable",
                    message: "Your device is not configured for biometric authentication",
                    preferredStyle: .alert
                )
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }
    }
    
    // Day 93 challenge
    private func unlockApp() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
        
        navigationItem.rightBarButtonItem = nil
        
        loadPeople()
    }
    
    private func loadPeople() {
        guard let people = UserDefaultsManager.get(forKey: .people) as [Person]? else { return }
        self.people = people
        collectionView.reloadData()
    }
    
    private func showOptions(for person: Person, at indexPath: IndexPath) {
        let index = indexPath.row
        
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
                
                guard let self = self, let newName = alertController?.textFields?[0].text else { return }
                self.people[index] = Person(name: newName, imageName: person.imageName)
                UserDefaultsManager.save(self.people, forKey: .people)
                self.collectionView.reloadData()
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alertController, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.collectionView.deleteItems(at: [indexPath])
            self.people.remove(at: index)
            UserDefaultsManager.save(self.people, forKey: .people)
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
        // `in`: adds that we want the path to be relative to the user's home directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

// MARK: - Data Source
extension ViewController {
    
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
        
        let path = getDocumentsDirectory().appendingPathComponent(person.imageName)
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
        let person = people[indexPath.item]
        showOptions(for: person, at: indexPath)
    }
    
}

/**
 - `UIImagePickerControllerDelegate` tells us when the user chooses an image or cancels the picker.
 - `UINavigationControllerDelegate` is needed because of `UIImagePickerControllerDelegate`.
 It has two optional methods to implement which are not necessary in this case.
 */
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     Returns when the user selected an image and it's being returned to you. This method needs to
     do several things:
    
     Extract the image from the dictionary that is passed as a parameter.
     Generate a unique filename for it.
     Convert it to a JPEG, then write that JPEG to disk.
     Dismiss the view controller.
     */
    
    /**
     This dictionary parameter will contain one of two keys: `.editedImage` (the image that was edited)
     or `.originalImage`. In our case, it should only ever be the former unless you change the
     `allowsEditing` property.
     */
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        /**
         All installed apps have a directory called Documents where you can save private
         information of the app, and it's also automatically synchronized with iCloud.
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", imageName: imageName)
        people.append(person)
        
        UserDefaultsManager.save(people, forKey: .people)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
}
