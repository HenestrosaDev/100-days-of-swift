//
//  CountryEnpoint.swift
//  CountryFacts
//
//  Created by JC on 8/4/23.
//

import Foundation

enum CountryEndpoint {
    case country(countryCode: String)
}

extension CountryEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .country(let countryCode):
            return "/v3.1/alpha/\(countryCode)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .country:
            return [
                URLQueryItem(
                    name: "fields",
                    value: "name,continents,capital,demonyms,population,area,idd,car,tld,timezones,currencies,languages,cca2"
                )
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .country:
            return .get
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .country:
            return nil
        }
    }

    var body: [String: String]? {
        switch self {
        case .country:
            return nil
        }
    }
    
}
