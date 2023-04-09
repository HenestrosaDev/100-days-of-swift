//
//  MainViewController.swift
//  PhotoCaptions
//
//  Created by JC on 5/4/23.
//

import UIKit

class MainViewController: UITableViewController {

    // MARK: Properties
    
    private var photos = [Photo]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPhotos()
    }
    
    // MARK: - Methods
    
    private func configureViewController() {
        title = "Photo Captions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        tableView.rowHeight = 95
        // Set the background color to "Default"
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func loadPhotos() {
        guard let photos = UserDefaultsManager.get(forKey: .photos) as [Photo]? else { return }
        self.photos = photos
        tableView.reloadData()
    }
    
    private func scale(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    @objc private func didTapAddButton() {
        let ac = UIAlertController(
            title: "Choose photo from",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        ac.addAction(UIAlertAction(title: "Camera", style: .default) {
            [weak self] _ in
            
            guard let self = self else { return }
            self.pickPhoto(isFromCamera: true)
        })
        
        ac.addAction(UIAlertAction(title: "Gallery", style: .default) {
            [weak self] _ in
            
            guard let self = self else { return }
            self.pickPhoto(isFromCamera: false)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func pickPhoto(isFromCamera: Bool) {
        let picker = UIImagePickerController()
        
        // Allows you to crop the image when selecting it, among other things
        picker.allowsEditing = true
        
        // Conforming to the protocol
        picker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera) && isFromCamera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    private func sharePhoto(photo: Photo) {
        let photoPath = getDocumentsDirectory().appendingPathComponent(photo.fileName)
        
        let viewController = UIActivityViewController(
            activityItems: [UIImage(contentsOfFile: photoPath.path)!, photo.caption],
            applicationActivities: []
        )

        /**
         This line is for iPad, because the activity view controller must be shown from somewhere on
         the screen. In this case, we are telling the view that it will pop up from a bar button item,
         which is the right bar button item.
         */
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(viewController, animated: true)
    }
    
}

// MARK: - Table View Delegate
extension MainViewController {
    
    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let photo = photos[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            let shareAction = UIAction(
                title: "Share photo",
                image: UIImage(systemName: "square.and.arrow.up.fill")
            ) { (action) in
                DispatchQueue.main.async { [weak self] in
                    self?.sharePhoto(photo: photo)
                }
            }
            
            return UIMenu(title: "Photo Options", children: [shareAction])
        }
    }
    
}

// MARK: - Data Source
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        let photo = photos[indexPath.row]
        let photoPath = getDocumentsDirectory().appendingPathComponent(photo.fileName)

        cell.textLabel?.text = photo.caption
        cell.imageView?.image = scale(
            image: UIImage(contentsOfFile: photoPath.path)!,
            to: CGSize(width: 110, height: 70)
        )
        cell.imageView?.layer.cornerRadius = 5
        cell.imageView?.layer.masksToBounds = true
        
        // Set the accessory type to an arrow
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let photo = photos[index]
        navigateToDetail(of: photo, in: index)
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            // Remove the item from the data source
            photos.remove(at: indexPath.row)
            UserDefaultsManager.save(photos, forKey: .photos)

            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: - ImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        /**
         All installed apps have a directory called Documents where you can save private
         information for the app, and it's also automatically synchronized with iCloud
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(caption: "Photo", fileName: imageName)
        photos.append(photo)
        UserDefaultsManager.save(photos, forKey: .photos)
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
}

// MARK: - Navigation
extension MainViewController {
 
    private func navigateToDetail(of photo: Photo, in index: Int) {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as? DetailViewController {
            vc.photos = photos
            vc.selectedPhoto = photo
            vc.selectedPhotoIndex = index
            show(vc, sender: self)
        }
    }
    
}
