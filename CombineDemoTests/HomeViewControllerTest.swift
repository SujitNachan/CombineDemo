//
//  HomeViewControllerTest.swift
//  CombineDemoTests
//
//  Created by  on 13/01/23.
//

import XCTest
import Combine
@testable import CombineDemo

class HomeViewControllerTest: XCTestCase {
    var sut: HomeViewController!
    var movieTableViewDataSource: MovieTableViewDataSourceMockProtocol!
    
    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController")
        sut.loadViewIfNeeded()
        movieTableViewDataSource = MovieTableViewDataSourceMock()
        sut.movieTableView?.dataSource = movieTableViewDataSource
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testFetchDataMethod() {
        movieTableViewDataSource.fetchData()
        XCTAssertTrue(movieTableViewDataSource.fetchDataCalled)
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
    
    func observeHomeDataModel() {
        observeHomeDataModelCalled = true
    }
    
    func fetchData() {
        fetchDataCalled = true
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
}
