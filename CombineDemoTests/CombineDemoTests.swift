//
//  CombineDemoTests.swift
//  CombineDemoTests
//
//  Created by  on 11/01/23.
//

import XCTest
import Combine
@testable import CombineDemo

final class CombineDemoTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var homeService: MockHomeService!
    var homeViewController: HomeViewController!
    
    override func setUp() {
        super.setUp()
        homeService = MockHomeService()
        homeViewModel = HomeViewModel(homeService: homeService)
        homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController")
    }
    
    override func tearDown() {
        super.tearDown()
        homeViewModel = nil
        homeService = nil
    }
    
    func testHomeViewControllerLoaded() {
        XCTAssertEqual(homeViewController.movieTableView?.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(homeViewController.movieTableView?.numberOfRows(inSection: 2), 2)
    }
    
    func testInvalidJson() {
        guard let url = URL(string: homeService.baseURL +  "/\(MockFiles.invalidJson.rawValue)") else { return }
        let request = URLRequest(url: url)
        homeViewModel.getHomeData()
    }
    
    /*func testFetchDataSuccess() {
        //given
        let movies: [Movie] = [Movie(rating: 1.5, id: 1, revenue: 300, releaseDate: "01/02/2020", director: Director(name: "Rajamauli", pictureUrl: "http://www.google.com"), posterUrl: "http://www.google.com", cast: [Cast(name: "Govinda", pictureUrl: "http://www.google.com", character: "Raja")], runtime: 40, title: "Raja Babu", overview: "good", reviews: 3, budget: 300, language: "Hindi", genres: ["Comedy"])]
        
        let staffPicks: [Movie] = [Movie(rating: 1.5, id: 1, revenue: 300, releaseDate: "01/02/2020", director: Director(name: "Rajamauli", pictureUrl: "http://www.google.com"), posterUrl: "http://www.google.com", cast: [Cast(name: "Govinda", pictureUrl: "http://www.google.com", character: "Raja")], runtime: 40, title: "Raja Babu", overview: "good", reviews: 3, budget: 300, language: "Hindi", genres: ["Comedy"]), Movie(rating: 1.5, id: 1, revenue: 300, releaseDate: "01/02/2020", director: Director(name: "Rajamauli", pictureUrl: "http://www.google.com"), posterUrl: "http://www.google.com", cast: [Cast(name: "Govinda", pictureUrl: "http://www.google.com", character: "Raja")], runtime: 40, title: "Raja Babu", overview: "good", reviews: 3, budget: 300, language: "Hindi", genres: ["Comedy"])]
        
        homeService.resultMovie = CurrentValueSubject(movies).eraseToAnyPublisher()
        homeService.resultStaffPicks = CurrentValueSubject(staffPicks).eraseToAnyPublisher()
        //when
        homeViewModel.getHomeData()
        
//        homeViewController.loadViewIfNeeded()
        
        //then
        
        XCTAssertEqual(homeViewModel.movies.count, 1)
        XCTAssertEqual(homeViewModel.staffPicks.count, 2)
        XCTAssertEqual(homeViewModel.staffPicksViewModels.count, 2)
        XCTAssertEqual(homeViewModel.favoriteMovieViewModels.count, 1)
    }*/
    
    /*func testFetchDataFailed() {
        homeService.resultMovie = Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        homeService.resultStaffPicks = Fail(error: NetworkError.responseError).eraseToAnyPublisher()
        //when
        homeViewModel.getHomeData()
        //then
        XCTAssertEqual(homeViewModel.movies.count, 0)
        XCTAssertEqual(homeViewModel.staffPicks.count, 0)
        XCTAssertEqual(homeViewModel.staffPicksViewModels.count, 0)
        XCTAssertEqual(homeViewModel.favoriteMovieViewModels.count, 0)
    }*/
}

class MockHomeService: HttpClient {
    var baseURL: String = "https://apps.agentur-loop.com/challenge"
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func fetch<T>(request: URLRequest) -> Future<T, Error> where T : Decodable {
        
        return Future<T, Error> { [weak self] promise in
            guard let self = self else { return }
            
            guard let fileName = request.url?.lastPathComponent,
                  let mockFile = MockFiles(rawValue: fileName) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            Bundle.main.decodeable(fileName: mockFile.rawValue, withExtension: "json")
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.cancellables)
        }
    }
}

extension MockHomeService: HomeServiceInterface {
    func fetchMovies(endPoint: String) -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: self.baseURL.appending("/\(endPoint)"))
        else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return fetch(request: URLRequest(url: url))
            .eraseToAnyPublisher()
    }
}
