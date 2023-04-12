//
//  Country.swift
//  CountryFacts
//
//  Created by JC on 7/4/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let country = try? JSONDecoder().decode(Country.self, from: jsonData)

// See country_sample.json to check the JSON format

import Foundation

// MARK: - Country typealias
typealias Countries = [Country]

typealias CountryName = String
typealias CountryFlagFilename = String
typealias CountryDict = [CountryName : CountryFlagFilename]

typealias LanguageCode = String
typealias LanguageName = String

// MARK: - Country
struct Country: Codable {
    let name: Name
    let currencies: [String : Currency]
    let idd: Idd
    let capital: [String]
    let languages: [LanguageCode : LanguageName] // example -> "por": "Portuguese"
    let area: Int
    let timezones: [String]
    let demonyms: Demonyms
    let population: Int
    let car: Car
    let tld: [String]
    let cca2: String
    let continents: [String]
}

// MARK: - Car
struct Car: Codable {
    let side: String
}

// MARK: - Currency
struct Currency: Codable {
    let name: String
    let symbol: String
}

// MARK: - Demonyms
struct Demonyms: Codable {
    let eng: Eng
    
    struct Eng: Codable {
        let m: String
    }
}

// MARK: - Idd
struct Idd: Codable {
    let root: String
    let suffixes: [String]
}

// MARK: - Name
struct Name: Codable {
    let common: String
    let official: String
}
