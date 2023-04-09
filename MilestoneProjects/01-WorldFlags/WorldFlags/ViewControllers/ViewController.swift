//
//  ViewController.swift
//  WorldFlags
//
//  Created by JC on 27/3/23.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Properties
    
    private var countryFlagDict = [[String : String]]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        loadImages()
    }
    
    // MARK: - Methods
    
    private func configureViewController() {
        title = "World Flags"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.rowHeight = 65
        // Set the background color to "Default"
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let filenames = try! fm.contentsOfDirectory(atPath: path)
        
        filenames.forEach { filename in
            if filename.hasSuffix("-sm.png") {
                let locale = Locale(identifier: Locale.current.languageCode ?? "en_US")
                if let countryName = locale.localizedString(
                    forRegionCode: filename.replacingOccurrences(of: "-sm.png", with: "")
                ) {
                    countryFlagDict.append([countryName : filename])
                }
            }
        }
        
        countryFlagDict = countryFlagDict.sorted {
            $0.keys.first!.localizedCaseInsensitiveCompare($1.keys.first!) == .orderedAscending
        }
    }
    
    private func scale(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
}

// MARK: - Data Source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryFlagDict.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countryFlagDict[indexPath.row]
        
        cell.textLabel?.text = country.keys.first!
        cell.imageView?.image = scale(
            image: UIImage(named: country.values.first!)!,
            to: CGSize(width: 65, height: 40)
        )
        
        // To avoid flags with white color to blend in with the bachgorund
        cell.imageView?.layer.borderColor = UIColor.gray.cgColor
        cell.imageView?.layer.borderWidth = 1
        
        // Set the accessory type to an arrow
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countryFlagDict[indexPath.row]
        navigateToDetail(countryName: country.keys.first!, imageFilename: country.values.first!)
    }

}

// MARK: - Navigation
extension ViewController {
 
    private func navigateToDetail(countryName: String, imageFilename: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.countryName = countryName
            vc.imageFilename = imageFilename.replacingOccurrences(of: "-sm", with: "-lg")
            
            show(vc, sender: self)
        }
    }
    
}
