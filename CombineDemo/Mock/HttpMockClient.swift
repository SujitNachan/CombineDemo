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
    case missingFileName = "missingfilename"
    case corruptedData = "corrupted-data.json"
}


enum ConfigurationError: Error {
    case MissingMockFile
    case CorruptedMockData
    case DecodingError
}

extension ConfigurationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .MissingMockFile:
            return NSLocalizedString("Missing Mock data file", comment: "Missing Mock data file")
        case .CorruptedMockData:
            return NSLocalizedString("Corrupted Mock data file", comment: "Corrupted Mock data file")
        case .DecodingError:
            return NSLocalizedString("Invalid Json data", comment: "Invalid json data")
        }
    }
}


/*extension Bundle{
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
}*/


class MockHttpClient: HttpClient {
    var baseURL: String = "https://apps.agentur-loop.com/mock"
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    var resultData: Array<Decodable> = []
    
    func fetch<T>(request: URLRequest) -> Future<T, Error> where T : Decodable {
        
        return Future<T, Error> { promise in
            
            guard let fileName = request.url?.lastPathComponent,
                  let mockFile = MockFiles(rawValue: fileName) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            guard let sourceUrl = Bundle.main.url(forResource: mockFile.rawValue, withExtension: nil) else {
                 promise(.failure(ConfigurationError.MissingMockFile))
                return
            }
            
            guard let data = try? Data(contentsOf: sourceUrl) else {
                promise(.failure(ConfigurationError.CorruptedMockData))
               return
            }

            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                promise(.failure(ConfigurationError.DecodingError))
               return
            }
            promise(.success(result))
        }
    }
}
