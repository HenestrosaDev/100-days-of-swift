//
//  ViewController.swift
//  StormViewer
//
//  Created by JC on 23/8/21.
//

import UIKit

/**
 This class is like the MainActivity from Android. We have to set it as the launch "activity" (don't know how they are called on iOS) in the Storyboard
 */
class ViewController: UITableViewController {

    var pictures = [Picture]()
    
    //Equals onCreate() in Android
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        //navigationController is the same as an ActionBar in Android
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(recommendTapped))
        
        //performSelector(inBackground: #selector(fetchPictures), with: nil)
        fetchPictures()
    }
    
    @objc func fetchPictures() {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath! //resources path of our project
        //Note: A bundle is a directory containing our compiled program and all our assets
        var items = try! fileManager.contentsOfDirectory(atPath: path) //gets the contents of the directory at the specified path
        //Challenge of the instructor
        items.sort()
        
        let defaults = UserDefaults.standard
        if let trackedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: trackedPictures)
            } catch {
                print("Failed to load people.")
            }
        } else {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(Picture(path: item, views: 0))
                }
            }
            save()
        }
    }
    
    @objc func recommendTapped() {
        let items = ["This app rocks!"]
        
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }
    
    //Lets the table know how many rows will be populated
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    //Lets the table know what information will display the items. Index path contains the section number and the row number (there is only one section in this table tho). Returns the cell to show in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell be a recycled cell from the table with the Identifier "Picture" at indexPath row number
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //We used the indexPath.row because we want to load, for ex., the 2nd element of the Array into the 2nd cell of the table
        cell.textLabel?.text = pictures[indexPath.row].path
        cell.detailTextLabel?.text = String(pictures[indexPath.row].views)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            viewController.selectedImage = pictures[indexPath.row].path
            pictures[indexPath.row].views += 1
            save()
            //Challenge of the instructor
            viewController.position = indexPath.row + 1
            viewController.totalImages = pictures.count
            //
            navigationController?.pushViewController(viewController, animated: true)
            tableView.reloadData()
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Saved to save")
        }
    }

}
