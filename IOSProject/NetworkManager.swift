//
//  NetworkManager.swift
//  IOSProject
//
//  Created by Emilien Champion on 03/03/2021.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case mimeType
    case emptyData
}

class NetworkManager {
    // MARK: - Properties
    
    static let sharedInstance = NetworkManager()
    
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
    
    
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Public Methods
    
    func fetchCharacters(completion: @escaping (Result<PaginatedElements<SerieCharacter>, Error>) -> Void) {
            let url = baseURL.appendingPathComponent("character")
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return // Handle error...
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.statusCode(httpResponse.statusCode)))
                    return // Handle error...
                }
                
                guard let mimeType = httpResponse.mimeType,
                    mimeType == "application/json" else {
                    completion(.failure(NetworkError.mimeType))
                    return // Handle error...
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return // Handle error...
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let dateString = try decoder.singleValueContainer().decode(String.self)
                        return NetworkManager.iso8601Formatter.date(from: dateString)!
                    })
                    let result = try jsonDecoder.decode(PaginatedElements<SerieCharacter>.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
                
                
                
                
                
            }
            task.resume()

    }
}
