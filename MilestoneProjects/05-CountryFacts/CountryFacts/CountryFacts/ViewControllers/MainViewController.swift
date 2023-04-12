//
//  MainViewController.swift
//  CountryFacts
//
//  Created by JC on 7/4/23.
//

import UIKit

class MainViewController: UITableViewController {
    
    // MARK: Properties
    
    private let dataSource = MainDataSource()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureTableView()
        configureSearchController()
        loadImages()
    }
    
    // MARK: - Methods
    
    private func configureTitle() {
        title = "Country Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 65
        
        /**
         Disables estimated header and footer heights. Adds the margin between the search
         controller and the header. Can be done for the footer as well.
         */
        tableView.estimatedSectionHeaderHeight = 0
        
        // Set the background color to "Default"
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func configureSearchController() {
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search country…"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = DeviceTypes.isiPhoneSE ? true : false
    }
    
    private func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let filenames = try! fm.contentsOfDirectory(atPath: path)
        
        filenames.forEach { filename in
            if filename.hasSuffix(ImageUtils.flagFileSuffix) {
                let locale = Locale(
                    identifier: Locale.current.language.languageCode?.identifier ?? "en_US"
                )
                if let countryName = locale.localizedString(
                    forRegionCode: filename.replacingOccurrences(
                        of: ImageUtils.flagFileSuffix,
                        with: ""
                    )
                ) {
                    dataSource.countriesDict.append([countryName : filename])
                }
            }
        }
        
        dataSource.countriesDict = dataSource.countriesDict.sorted {
            $0.keys.first!.localizedCaseInsensitiveCompare($1.keys.first!) == .orderedAscending
        }
    }

    private func filterContent(for searchText: String) {
        dataSource.isFiltering = isFiltering
        dataSource.filteredCountries = dataSource.countriesDict.filter {
            $0.keys.first!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - Search results updater
extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
    
}

// MARK: - UITableViewDelegate
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .cell) }
        
        let row = indexPath.row
        let countryDict = dataSource.country(at: row)
        let countryCode = countryDict.values.first!.replacingOccurrences(
            of: ImageUtils.flagFileSuffix,
            with: ""
        )
        
        navigateToDetail(countryDict: countryDict, countryCode: countryCode)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Navigation
extension MainViewController {
 
    private func navigateToDetail(countryDict: CountryDict, countryCode: String) {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: DetailViewController.identifier
        ) as? DetailViewController {
            let countryRepository = CountryService(httpClient: HTTPClient())
            
            Task {
                let result = await countryRepository.fetchCountry(
                    countryCode: countryCode
                )
                
                switch result {
                case .success(let country):
                    vc.dataSource.country = country
                    show(vc, sender: self)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
