//
//  MockService.swift
//  CombineDemo
//
//  Created by  on 16/01/23.
//

import Foundation
import Combine

enum MockFiles: String {
    case invalidJson = "invalid-json.json"
    case fetchMovieSuccess = "movies.json"
    case fetchStaffPicksSuccess = "staff-picks.json"
    case fetchMovieFailed = "fetch-movie-failed.json"
    case fetchStaffPicksFailed = "fetch-staff-picks-failed.json"
}


enum ConfigurationError: Error {
    case MissingMockFile
    case CorruptedMockData
}

extension ConfigurationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .MissingMockFile:
            return NSLocalizedString("Missing Mock data file", comment: "Missing Mock data file")
        case .CorruptedMockData:
            return NSLocalizedString("Corrupted Mock data file", comment: "Corrupted Mock data file")
        }
    }
}


extension Bundle{
    func readFile(file: String, withExtension ex: String) -> AnyPublisher<Data, Error> {
        self.url(forResource: file, withExtension: ex)
            .publisher
            .tryMap{ string in
                guard let data = try? Data(contentsOf: string) else {
                    fatalError("Failed to load \(file) from bundle.")
                }
                return data
            }
            .mapError { error in
                return error
            }.eraseToAnyPublisher()
    }
    
    func decodeable<T: Decodable>(fileName: String, withExtension ex: String) -> AnyPublisher<T, Error> {
        Bundle.main.readFile(file: fileName, withExtension: ex)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
