//
//  MainDataSource.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit

class MainDataSource: NSObject {
    
    var countriesDict = [CountryDict]()
    var filteredCountries = [CountryDict]()
    var isFiltering = false
    
    func country(at row: Int) -> CountryDict {
        return isFiltering ? filteredCountries[row] : countriesDict[row]
    }
    
}

extension MainDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (isFiltering, filteredCountries.isEmpty) {
        case (true, true):
            return nil
            
        case (true, false):
            return "Top matches"
            
        case (false, true), (false, false):
            return "All countries and territories"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering && filteredCountries.isEmpty {
            tableView.setEmptyMessage()
        } else {
            tableView.restoreInitialState()
        }
        
        return isFiltering ? filteredCountries.count : countriesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CountryCell.identifier,
            for: indexPath
        ) as! CountryCell
        
        let country = country(at: indexPath.row)
        cell.configure(for: country.keys.first!, imageName: country.values.first!)
        
        return cell
    }
    
}
