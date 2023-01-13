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
    private var homeViewModel: HomeViewModel!
    
    override func setUp() {
        homeViewModel = HomeViewModel(homeService: HomeService())
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        homeViewModel = nil
    }
    
//    func testHomeViewModel() {
//        sut.
//    }
}

class HomeDataModelMock {
    var mockValues: [Movie] = []
    var fetchValueCounter = 0
    var expectation: XCTestExpectation?
    
//    func fetch
}
