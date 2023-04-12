//
//  DetailViewController.swift
//  CountryFacts
//
//  Created by JC on 7/4/23.
//

import UIKit

class DetailViewController: UITableViewController {
    
    // MARK: Properties
    
    static let identifier = "DetailViewController"
    
    let dataSource = DetailDataSource()
    private var country: Country { return dataSource.country }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        title = country.name.common
        
        let readOnWikipediaAction = UIAction(
            title: "Read on Wikipedia",
            image: UIImage(systemName: "book")
        ) { [weak self] action in
            self?.readOnWikipedia()
        }
        
        let shareAction = UIAction(
            title: "Share",
            image: UIImage(systemName: "square.and.arrow.up")
        ) { [weak self] action in
            self?.share()
        }
        
        let actions = [readOnWikipediaAction, shareAction]
        
        let menu = UIMenu(
            title: "More",
            image: nil,
            identifier: nil,
            options: [],
            children: actions
        )
        
        let moreBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.keyboardDismissMode = .onDrag
        
        /**
         Disables estimated header and footer heights. Adds the margin between the search
         controller and the header. Can be done for the footer as well.
         */
        tableView.estimatedSectionHeaderHeight = 0
        
        // Set the background color to "Default"
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    // MARK: Actions
    
    private func readOnWikipedia() {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let countryNameEncoded = country.name.common.replacingOccurrences(of: " ", with: "_")
        let wikipediaUrl = "https://\(languageCode).wikipedia.org/wiki/\(countryNameEncoded)"
        
        guard let url = URL(string: wikipediaUrl) else {
            if UIDevice.isHapticAvailable {
                UIDevice.hapticFeedback(from: .button, isSuccessful: false)
            }
            return
        }
        
        if UIDevice.isHapticAvailable {
            UIDevice.hapticFeedback(from: .button, isSuccessful: true)
        }
        
        openSafari(with: url)
    }
    
    private func share() {
        if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button) }
        
        let flagImage = UIImage(named: ImageUtils.getFlagFileName(countryCode: country.cca2))
        let text = dataSource.getShareText()
        
        let vc = UIActivityViewController(
            activityItems: [flagImage as Any, text],
            applicationActivities: nil
        )
        
        /**
         This line is for iPad, because the activity view controller must be shown from somewhere
         on the screen. In this case, we are telling the view that it will pop up from a bar button
         item, which is the right bar button item.
         */
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension DetailViewController {
    
    // Enables press and hold to copy the detail view cell's content
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPath.section != 0 else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let shareAction = UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.clipboard")
            ) { (action) in
                guard let cell = tableView.cellForRow(at: indexPath) else { return }
                guard cell.textLabel?.text != nil else { return }
                UIPasteboard.general.string = cell.textLabel?.text
            }
            
            return UIMenu(title: "", children: [shareAction])
        }
    }
    
}
