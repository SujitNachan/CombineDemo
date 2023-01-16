//
//  APIManager.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import Foundation
import Combine

enum Endpoint: String {
    case movies = "movies.json"
    case staffPicks = "staff_picks.json"
}

protocol HttpClient: AnyObject {
    var baseURL: String { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func fetch<T: Decodable>(request: URLRequest) -> Future<T, Error>
}

extension HttpClient {
    func fetch<T: Decodable>(request: URLRequest) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return }
            print("URL is \(request.url?.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
