//
//  ViewController.swift
//  StormViewer
//
//  Created by JC on 12/3/23.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: Properties
    
    var pictures: [String] = []
    var pictureShownCounts: [String : Int] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    // MARK: - Methods
    
    @objc private func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        items.forEach { item in
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        
        if let savedCounts = UserDefaults.standard.data(forKey: "pictureShownCount") {
            do {
                pictureShownCounts = try JSONDecoder().decode([String : Int].self, from: savedCounts)
            } catch {
                print("Failed to load picture view counts.")
            }
        } else {
            pictures.forEach { picture in
                pictureShownCounts.updateValue(0, forKey: picture)
            }
        }
    }

    private func save() {
        if let savedData = try? JSONEncoder().encode(pictureShownCounts) {
            UserDefaults.standard.set(savedData, forKey: "pictureShownCount")
        }
        
        tableView.reloadData()
    }

}

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pictureName = pictures[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictureName
        cell.detailTextLabel?.text = "Times shown \(pictureShownCounts[pictureName] ?? 0)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pictureName = pictures[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictureName
            vc.titleString = "Picture \(indexPath.row + 1) of \(pictures.count)"
            
            if pictureShownCounts.keys.contains(pictureName) {
                let currentViewCount = pictureShownCounts[pictureName]!
                pictureShownCounts.updateValue(currentViewCount + 1, forKey: pictureName)
                
                save()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
