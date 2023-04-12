//
//  CountryService.swift
//  CountryFacts
//
//  Created by JC on 7/4/23.
//

import Foundation

class CountryService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchCountry(countryCode: String) async -> Result<Country, APIError> {
        return await httpClient.sendRequest(
            endpoint: CountryEndpoint.country(countryCode: countryCode),
            responseType: Country.self
        )
    }
    
}
