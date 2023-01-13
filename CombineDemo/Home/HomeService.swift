//
//  HomeService.swift
//  CombineDemo
//
//  Created by  on 13/01/23.
//

import Foundation
import Combine

protocol HomeServiceInterface {
    var fetchMovie: AnyPublisher<[Movie],Error> { get }
    var fetchStaffPicks: AnyPublisher<[Movie],Error> { get }
}

class HomeService: ServiceProtocol, HomeServiceInterface {
    var baseURL: String = "https://apps.agentur-loop.com/challenge"
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var fetchMovie: AnyPublisher<[Movie],Error> {
        return getData(endpoint: .movies, type: Movie.self)
            .eraseToAnyPublisher()
    }
    
    var fetchStaffPicks: AnyPublisher<[Movie],Error> {
        return getData(endpoint: .staffPicks, type: Movie.self)
            .eraseToAnyPublisher()
    }
}
