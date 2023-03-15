//
//  ViewController.swift
//  EasyBrowser
//
//  Created by JC on 27/8/21.
//

import UIKit

/**
 This class is like the MainActivity from Android. We have to set it as the launch ViewController in
 the Storyboard
 */
class ViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com"]
    
    // Same as onCreate() in Android
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        // navigationBar is the same as an ActionBar in Android
        navigationController?.navigationBar.prefersLargeTitles = true
        
        websites.sort()
    }
    
    // Lets the table know how many rows will be populated
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    /**
     Lets the table know what information will display the items. indexPath contains the section
     number and the row number (there is only one section in this table tho). Returns the cell
     to show in the table.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Recycled cell from the table with the Identifier "Picture" at indexPath row number.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Url", for: indexPath)
        
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            viewController.selectedWebsite = websites[indexPath.row]
            viewController.websites = websites
            
            //Initiates the DetailViewController and puts this one on the stack
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }

}
