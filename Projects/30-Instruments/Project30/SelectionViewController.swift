//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
    
    // MARK: Public Properties
    
    var shouldRefresh = false
    
    // MARK: Private Properties
    
	private var itemsName = [String]() // this is the array that will store the filenames to load
    
    // Challenge 3
    private var itemsImage = [String : UIImage]()
	
    /**
     BEFORE:
     viewControllers is a cache of the detail view controllers, which is never actually used.
     
     var viewControllers = [UIViewController]()
     */

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        
        /**
         REFACTORIZATION:
         
         Registers a class to use in creating new table cells. This means that, whenever the table
         view requests a cell, it will get a reusable cell with the identifier "Cell".
         */
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default

        // Challenge 1 (remove all the force unwraps)
        guard let path = Bundle.main.resourcePath else {
            showAlert(title: "Error", message: "There was an error while getting the images")
            return
        }
        
		if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
			for item in tempItems {
                // BEFORE:
				// if item.range(of: "Large") != nil {
                
                // AFTER (Challenge 3)
                if item.range(of: "Thumb.") != nil {
					itemsName.append(item)
                    
                    // Challenge 3 (bonus)
                    let imagePath = getDocumentsDirectory().appendingPathComponent(item)
                    itemsImage[item] =
                        UIImage(contentsOfFile: imagePath.path) ?? getRoundedImage(for: item)
				}
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if shouldRefresh {
			// We've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return itemsName.count * 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		/**
         BEFORE:
         
         This way, iOS would be forced to create a new cell from scratch for each cell in the
         table view, which is not the most efficient way to do that in terms of performance
         because it would be better to re-use an unused existing cell instead of creating
         unnecessary new ones.
         
         let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
         */

        /**
         AFTER:
         
         This way, iOS would only use as many cells as needed and then it would re-use them
         instead of creating one cell for each row to be loaded in the table view.
         
         One important thing to bear in mind is that we need to register the re-usable
         cell identifier in the viewDidLoad. This is needed in order to avoid doing the following:
         
         var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
         
         if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
         }
         
         If you notice, we would have to check if there is already an available cell in order to
         reuse it. To avoid that, we use the register() method in the viewDidLoad, just as mentioned
         above.
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Each image stores how often it's been tapped
        let itemName = itemsName[indexPath.row % itemsName.count]
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: itemName))"
        
        // Challenge 3
		cell.imageView?.image = itemsImage[itemName]

		// Gives the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        
        /**
         REFACTORIZATION:
         
         To avoid iOS from automatically calculate the shadow path for the image, we can give it
         the exact shadow path to use, which is the renderRect.
         */
        cell.imageView?.layer.shadowPath = UIBezierPath(
            ovalIn: CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        ).cgPath

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
        
        // Load the large photo in the ImageViewController
        vc.imageName = itemsName[indexPath.row % itemsName.count]
            .replacingOccurrences(of: "Thumb", with: "Large")
        
		vc.owner = self

		// Mark us as not needing a counter reload when we return
        shouldRefresh = false

		// BEFORE: Add to our view controller cache and show (commented because is not actually used)
		// viewControllers.append(vc)
        
        // AFTER:
        // Challenge 1 (remove all the force unwraps)
		navigationController?.pushViewController(vc, animated: true)
	}
    
    // MARK: Private Methods
    
    // Challenge 3
    private func getRoundedImage(for name: String) -> UIImage {
        /**
         Renders the original image, which has, in average, a size of 750x50 - way more than
         we need. The original image might only take up 500 KB on disk, but once they are
         uncompressed by iOS, they'll need around 45 MB of RAM (per image!)
         */
        // Challenge 1 (remove all the force unwraps)
        guard let originalImage = UIImage(named: name) else {
            fatalError("The image for \(name) could not be loaded")
        }

        /**
         This makes the image scale down to the size it needs to be for actual usage, so it will
         immediately improve the app's performance.
         */
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

        let roundedImage = renderer.image { ctx in
            // BEFORE:
            // ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            
            // AFTER: Shape in which the image will be drawn
            ctx.cgContext.addEllipse(in: renderRect)
            
            /**
             clip() has the effect of only drawing things that lie inside the path, so when the
             UIImage is drawn, only the parts that lie inside the elliptical path are visible, thus
             rounding the corners.
             */
            ctx.cgContext.clip()

            // BEFORE:
            // originalImage.draw(at: CGPoint.zero)
            
            // AFTER:
            originalImage.draw(in: renderRect)
        }
        
        // Challenge 3 (bonus)
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        if let pngData = roundedImage.pngData() {
            try? pngData.write(to: imagePath)
        }
        
        return roundedImage
    }
    
    // Challenge 3 (bonus)
    private func getDocumentsDirectory() -> URL {
        // in: adds that we want the path to be relative to the user's home directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
