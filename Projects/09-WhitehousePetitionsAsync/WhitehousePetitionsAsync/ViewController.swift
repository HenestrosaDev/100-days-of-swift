//
//  ViewController.swift
//  WhitehousePetitionsAsync
//
//  Created by JC on 1/9/21.
//

import UIKit

/**
 Note: 2º APPROACH is the best build of the app because it handles the fetching task in background
 and we the UI code is done in the main thread.
 */
class ViewController: UITableViewController {
    
    var url: String! = nil
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse news"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showUrl))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(promptForFilter)
        )
        
        // 2º APPROACH 2º Step
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    // 2º APPROACH 1º STEP
    @objc func fetchJSON() {
        
        let urlString: String
        
        // This URL caches the data gotten from the White House API, so it is probably not up to date.
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        url = urlString
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func promptForFilter() {
        let alertController = UIAlertController(title: "Enter filter", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        // The closure is the handler
        let submitAction = UIAlertAction(title: "Filter", style: .default) {
            /**
             [weak self, weak alertController] declares the parameters coming into the closure.
             They can be strong, weak and/or unowned. The Readme has more details about these terms.
             self makes reference to the ViewController of the class itself
             */
            [weak self, weak alertController] _ in
            
            //alertController?.textFields?[0].text get the text from the first textfield of the alertController
            guard let filter = alertController?.textFields?[0].text?.lowercased() else { return }
            self?.filter(filter.lowercased())
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    func filter(_ filter: String) {
        if !filteredPetitions.isEmpty {
            filteredPetitions.removeAll()
        }
        
        for petition in petitions {
            if petition.title.lowercased().contains(filter) || petition.body.lowercased().contains(filter) {
                filteredPetitions.append(petition)
            }
        }
        
        if filteredPetitions.isEmpty {
            showError()
        } else {
            isFiltering = true
            tableView.reloadData()
        }
    }
    
    @objc func showUrl() {
        let alertController = UIAlertController(title: "Data provided by", message: url, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    @objc func showError() {
        let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    /*
    func showError(title: String, message: String) {
        // 1º APPROACH 3º Step
        // We put the task back inside the main thread
        DispatchQueue.main.async {
            [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true)
        }
    }*/
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        /**
         Tries to decode the JSON to a Petitions object. The .self is telling: Find this type
         (Petitions) and make an instance of it from the JSON.
         */
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results

            /**
             * 1º APPROACH 2º STEP
             * Main thread, where the UIs changes MUST be done
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
             */
            
            // 2º APPROACH 3º STEP
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
        // END OF 2º APPROACH
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var petition: Petition!
        if isFiltering {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        
        if isFiltering {
            detailViewController.detailItem = filteredPetitions[indexPath.row]
        } else {
            detailViewController.detailItem = petitions[indexPath.row]
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}
