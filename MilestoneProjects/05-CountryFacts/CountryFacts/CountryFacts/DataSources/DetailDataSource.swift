//
//  DetailDataSource.swift
//  CountryFacts
//
//  Created by JC on 9/4/23.
//

import UIKit

class DetailDataSource: NSObject {
    
    var country: Country!
    
    private var capital: String {
        let capitals = country.capital.joined(separator: ", ")
        return capitals.isEmpty ? "N/A" : capitals
    }
    
    private var callingCode: String {
        let suffix = country.idd.suffixes.count > 1 ? "" : (country.idd.suffixes[safe: 0] ?? "N/A")
        return country.idd.root + suffix
    }
    
    private var tld: String {
        let tld = country.tld.joined(separator: "\n")
        return tld.isEmpty ? "N/A" : tld
    }
    
    private let cellIdentifier = "DetailCell"
    
    private enum Section: String {
        case flag = "Flag"
        case general = "General"
        case languages = "Official languages"
        case timezones = "Timezones"
        case currencies = "Currencies"
    }
    
    private let sectionTitles: [Section] = [
        .flag,
        .general,
        .languages,
        .timezones,
        .currencies
    ]
    
    private enum GeneralSection: String {
        case officialName = "Official name"
        case capital = "Capital"
        case demonym = "Demonym"
        case population = "Population"
        case area = "Area"
        case callingCode = "Calling code"
        case driveSide = "Drive side"
        case iso3166 = "ISO 3166-2 code"
        case tld = "Internet TLD"
    }
    
    private let generalSectionTitles: [GeneralSection] = [
        .officialName,
        .capital,
        .demonym,
        .population,
        .area,
        .callingCode,
        .driveSide,
        .iso3166,
        .tld
    ]
    
    func getShareText() -> String {
        var text = """
        Here are some facts about \(country.name.common)!
        
        - \(GeneralSection.officialName.rawValue): \(country.name.common)
        - \(GeneralSection.capital.rawValue): \(capital)
        - \(GeneralSection.demonym.rawValue): \(country.demonyms)
        - \(GeneralSection.population.rawValue): \(country.population)
        - \(GeneralSection.area.rawValue): \(country.area)
        - \(GeneralSection.callingCode.rawValue): \(callingCode)
        - \(GeneralSection.driveSide.rawValue): \(country.car.side)
        - \(GeneralSection.iso3166.rawValue): \(country.cca2)
        - \(GeneralSection.tld.rawValue): \(tld)
        """
        
        return text
    }
    
}

extension DetailDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTitles[section] {
        case .flag: return 1
        case .general: return generalSectionTitles.count
        case .languages: return country.languages.count
        case .timezones: return country.timezones.count
        case .currencies: return country.currencies.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sectionTitles[indexPath.section]
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        switch section {
        case .flag:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FlagCell.identifier
            ) as! FlagCell
            
            cell.configure(countryCode: country.cca2)
            return cell
            
        case .general:
            let generalSection = generalSectionTitles[row]
            
            var title = generalSection.rawValue
            var value = ""
                
            switch generalSection {
            case .officialName:
                value = country.name.official
                
            case .capital:
                if country.capital.count > 1 {
                    title += "s"
                }
                value = capital
                
            case .demonym:
                value = country.demonyms.eng.m
                
            case .population:
                value = country.population.formattedWithSeparator() ?? "N/A"
                
            case .area:
                value = "\(country.area.formattedWithSeparator() ?? "N/A") km²"
                
            case .callingCode:
                value = callingCode
                
            case .driveSide:
                value = country.car.side
                
            case .iso3166:
                value = country.cca2
                
            case .tld:
                if country.tld.count > 1 {
                    title += "s"
                }
                value = tld
            }
                
            let attributedText = NSAttributedString.attributedText(
                withString: "\(title): \(value)",
                boldString: title
            )
            cell.textLabel?.attributedText = attributedText
            
        case .languages:
            cell.textLabel?.text = Array(country.languages.values)[row]
            
        case .timezones:
            cell.textLabel?.text = country.timezones[row]
            
        case .currencies:
            let name = Array(country.currencies.values)[row].name
            let code = Array(country.currencies.keys)[row]
            cell.textLabel?.text = "\(name) (\(code))"
        }
        
        return cell
    }
    
}
