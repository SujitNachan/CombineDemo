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
//    private var homeViewModel: HomeViewModel!
    
    override func setUp() {
//        homeViewModel = HomeViewModel(homeService: HomeService())
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
//        homeViewModel = nil
    }
    
//    func testHomeViewModel() {
//        sut.
//    }
}

class MockHomeService: ServiceProtocol {
    var baseURL: String = ""
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var isMockHomeServiceCalled = false
    
    var result: Future<[T], Error>?
    
    func getData<T>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> where T : Decodable {
        isMockHomeServiceCalled = true
        
        return Future<[AnyObject]>
    }
}
