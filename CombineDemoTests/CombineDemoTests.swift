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
    
    func testInvalidURL() {
        let expectation = self.expectation(description: "InvalidURL")
        apiClient.baseURL = "@$ˆ&*#@!"
        homeViewModel.fetchMovies(endPoint: "@$ˆ&*#@!")
        homeViewModel.errorSubject.sink { error in
            XCTAssertEqual(NetworkError.invalidURL.localizedDescription, error.localizedDescription)
            print(error)
            expectation.fulfill()
        }.store(in: &cancellable)
        waitForExpectations(timeout: 3)
    }
    
    func testFetchMoviesInvalidURL() {
        let expectation = self.expectation(description: "FetchMoviesInvalidURL")
        homeViewModel.fetchMovies(endPoint: "invalidFileName")
        homeViewModel.errorSubject.sink { error in
            XCTAssertEqual(NetworkError.invalidURL.localizedDescription, error.localizedDescription)
            print(error)
            expectation.fulfill()
        }.store(in: &cancellable)
        waitForExpectations(timeout: 3)
    }
    
    func testFetchMoviesFileNameNotFound() {
        let expectation = self.expectation(description: "FetchMoviesFileNameNotFound")
        homeViewModel.fetchMovies(endPoint: MockFiles.missingFileName.rawValue)
        homeViewModel.errorSubject.sink { error in
            XCTAssertEqual(ConfigurationError.MissingMockFile.localizedDescription, error.localizedDescription)
            print(error)
            expectation.fulfill()
        }.store(in: &cancellable)
        waitForExpectations(timeout: 3)
    }
    
//    func testFetchMoviesCorruptedData() {
//        let expectation = self.expectation(description: "FetchMoviesCorruptedData")
//        homeViewModel.fetchMovies(endPoint: MockFiles.corruptedData.rawValue)
//        homeViewModel.errorSubject.sink { error in
//            XCTAssertEqual(ConfigurationError.CorruptedMockData.localizedDescription, error.localizedDescription)
//            print(error)
//            expectation.fulfill()
//        }.store(in: &cancellable)
//        waitForExpectations(timeout: 3)
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
    
    func testStaffPicksFailed() {
        let expectation = self.expectation(description: "StaffPicksFailed")
        homeViewModel.fetchStaffPicks(endPoint: "invalidFileName")
        homeViewModel.errorSubject.sink { error in
            XCTAssertEqual(NetworkError.invalidURL.localizedDescription, error.localizedDescription)
            expectation.fulfill()
        }.store(in: &cancellable)
        waitForExpectations(timeout: 3)
    }
}
