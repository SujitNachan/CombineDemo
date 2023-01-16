//
//  HomeService.swift
//  CombineDemo
//
//  Created by  on 13/01/23.
//

import Foundation
import Combine

protocol HomeServiceInterface {
    func fetchMovies(endPoint: String) -> AnyPublisher<[Movie],Error>
}

class HomeServiceImplementation: HttpClient, HomeServiceInterface {
    var baseURL: String = "https://apps.agentur-loop.com/challenge"
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    func fetchMovies(endPoint: String) -> AnyPublisher<[Movie],Error> {
        guard let url = URL(string: self.baseURL.appending("/\(endPoint)"))
        else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return fetch(request: URLRequest(url: url))
            .eraseToAnyPublisher()
    }
}
