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

class HomeServiceImplementation: HomeServiceInterface {
    var apiClient: HttpClient
    
    init(apiClient: HttpClient) {
        self.apiClient = apiClient
    }
    
    func fetchMovies(endPoint: String) -> AnyPublisher<[Movie],Error> {
        guard let url = URL(string: self.apiClient.baseURL.appending("/\(endPoint)"))
        else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return self.apiClient.fetch(request: URLRequest(url: url))
            .eraseToAnyPublisher()
    }
}
