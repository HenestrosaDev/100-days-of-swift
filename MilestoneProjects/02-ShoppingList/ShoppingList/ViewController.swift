//
//  ViewController.swift
//  ShoppingList
//
//  Created by JC on 29/3/23.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: Properties
    
    private var items = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        loadItems()
    }
    
    // MARK: - Methods

    private func configureViewController() {
        title = "Shopping List"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(didTapShare)
            ),
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAdd)
            )
        ]
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(didTapTrash)
        )
    }
    
    private func loadItems() {
        items = UserDefaultsManager.get(forKey: .shoppingList) as [String]? ?? []
    }
    
    /**
     Prompt a `UIAlertController` with a textfield.
     
     - Parameters:
        - title: UIAlertController's title.
        - item: The selected item to edit. `nil` if the user is creating a new item instead.
        - completion: The block to execute when the user taps on the `Submit` action. This block
        has no return value and takes the value of the textfield as a parameter.
     */
    private func promptTextfield(title: String, item: String? = nil, completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        alertController.textFields?[0].text = item
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            
            guard let self = self, let alertController = alertController else { return }
            
            guard let answer = alertController.textFields?[0].text else { return }
            completion(answer)
            self.tableView.reloadData()
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: Actions
    
    @objc private func didTapShare() {
        let itemsString = items.isEmpty ? "" : "- " + items.joined(separator: "\n- ")
        
        let viewController = UIActivityViewController(
            activityItems: [itemsString],
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
    
    @objc private func didTapTrash() {
        items.removeAll()
        tableView.reloadData()
    }

    @objc private func didTapAdd() {
        promptTextfield(title: "Enter shopping list item") { answer in
            self.items.append(answer)
            UserDefaultsManager.save(self.items, forKey: .shoppingList)
        }
    }
    
}


// MARK: - Data Source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            tableView.setEmptyMessage("No Results")
        } else {
            tableView.restoreInitialState()
        }
        
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        promptTextfield(title: "Edit shopping list item", item: items[indexPath.row]) { answer in
            self.items[indexPath.row] = answer
            UserDefaultsManager.save(self.items, forKey: .shoppingList)
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            // Remove the item from the data source
            items.remove(at: indexPath.row)
            UserDefaultsManager.save(items, forKey: .shoppingList)

            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
