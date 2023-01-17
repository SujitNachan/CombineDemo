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
    var apiClient: MockHttpClient!
//    var homeViewController: HomeViewController!
    var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        apiClient = MockHttpClient()
        homeViewModel = HomeViewModel(homeService: HomeServiceImplementation(apiClient: apiClient))
//        homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController")
    }
    
    override func tearDown() {
        super.tearDown()
        apiClient = nil
        homeViewModel = nil
    }
    
//    func testHomeViewControllerLoaded() {
//        XCTAssertEqual(homeViewController.movieTableView?.numberOfRows(inSection: 0), 1)
//        XCTAssertEqual(homeViewController.movieTableView?.numberOfRows(inSection: 2), 2)
//    }
    
    func testInvalidJson() {
        let expectation = self.expectation(description: "InvalidJson")
        homeViewModel.fetchMovies(endPoint: MockFiles.invalidJson.rawValue)
        homeViewModel.errorSubject.sink { error in
            XCTAssertEqual(ConfigurationError.DecodingError.localizedDescription, error.localizedDescription)
            expectation.fulfill()
        }.store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
    }
    
    func testFetchMoviesSuccess() {
        let expectation = self.expectation(description: "fetchMoviesSuccess")
        homeViewModel.fetchMovies(endPoint: MockFiles.fetchMovieSuccess.rawValue)
        homeViewModel.homeViewModelChanageSubject
            .sink { homeViewModel in
            XCTAssertEqual(homeViewModel.movies.count, 2)
            expectation.fulfill()
        }.store(in: &cancellable)
        waitForExpectations(timeout: 3)
    }
}
