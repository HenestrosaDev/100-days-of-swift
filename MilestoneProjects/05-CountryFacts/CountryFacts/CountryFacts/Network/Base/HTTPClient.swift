//
//  NetworkManager.swift
//  CountryFacts
//
//  Created by JC on 7/4/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed
    case unauthorized
}

class HTTPClient {
    
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async
    -> Result<T, APIError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                
                guard let decodedResponse = try? decoder.decode(responseType, from: data) else {
                    return .failure(.invalidData)
                }
                
                return .success(decodedResponse)
            
            case 401:
                return .failure(.unauthorized)
            
            default:
                return .failure(.requestFailed)
            }
        } catch {
            return .failure(.invalidResponse)
        }
    }
    
}
