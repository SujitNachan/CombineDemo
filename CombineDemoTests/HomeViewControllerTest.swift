//
//  HomeViewControllerTest.swift
//  CombineDemoTests
//
//  Created by  on 13/01/23.
//

import XCTest
import Combine
@testable import CombineDemo

/*
class HomeViewControllerTest: XCTestCase {
    var sut: HomeViewController!
    var movieTableViewDataSource: MovieTableViewDataSourceMockProtocol!
    
    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController")
        sut.loadViewIfNeeded()
        movieTableViewDataSource = MovieTableViewDataSourceMock(mockHomeViewModel: MockHomeViewModel(mockHomeService: MockService()))
        sut.movieTableView?.dataSource = movieTableViewDataSource
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testFetchDataMethod() {
        XCTAssertEqual(movieTableViewDataSource.movies.count, 1)
        XCTAssertEqual(movieTableViewDataSource.staffPicks.count, 1)
    }
    
    func testobserveHomeDataModelMethod() {
        movieTableViewDataSource.observeHomeDataModel()
        XCTAssertTrue(movieTableViewDataSource.observeHomeDataModelCalled)
    }
    
    func testNumberOfSection() {
        XCTAssertEqual(movieTableViewDataSource.numberOfSections(in: sut.movieTableView!),0)
    }
    
    func testNumberOfRowsInSection() {
        XCTAssertEqual(movieTableViewDataSource.tableView(sut.movieTableView!, numberOfRowsInSection: 0),0)
    }
}


protocol MovieTableViewDataSourceMockProtocol: MovieTableViewDataSourceProtocol {
    var observeHomeDataModelCalled: Bool { get set }
    var fetchDataCalled: Bool { get set }
    
    var staffPicks: [StaffPicksViewModel] { get set }
    var movies: [FavoriteMovieViewModel] { get set }
    
    var reloadTableSubject: PassthroughSubject<Void,Never> { get set }
    
    func observeHomeDataModel()
    func fetchData()
    
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}


class MovieTableViewDataSourceMock: NSObject, MovieTableViewDataSourceMockProtocol {
    var staffPicks: [StaffPicksViewModel] = []
    
    var movies: [FavoriteMovieViewModel] = []
    
    var reloadTableSubject: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    var observeHomeDataModelCalled = false
    var fetchDataCalled = false
    var mockHomeViewModel: MockHomeViewModel
    
    init(mockHomeViewModel: MockHomeViewModel) {
        self.mockHomeViewModel = mockHomeViewModel
    }
    
    func observeHomeDataModel() {
        observeHomeDataModelCalled = true
        self.reloadTableSubject.send()
    }
    
    func fetchData() {
        self.mockHomeViewModel.staffPicks = getMockMovieArray()
        self.mockHomeViewModel.movies = getMockMovieArray()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func getMockMovieArray() -> [Movie] {
        [Movie(rating: 1.5, id: 1, revenue: 300, releaseDate: "01/02/2020", director: Director(name: "Rajamauli", pictureUrl: "http://www.google.com"), posterUrl: "http://www.google.com", cast: [Cast(name: "Govinda", pictureUrl: "http://www.google.com", character: "Raja")], runtime: 40, title: "Raja Babu", overview: "good", reviews: 3, budget: 300, language: "Hindi", genres: ["Comedy"])]
    }
}

class MockService: ServiceProtocol {
    var baseURL: String = ""
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
}

class MockHomeViewModel: HomeDataModelProtocol {
    var movies: [Movie] = []
    var staffPicks: [Movie] = []
    var mockHomeService: ServiceProtocol
    
    init(mockHomeService: ServiceProtocol) {
        self.mockHomeService = mockHomeService
    }
}
*/
