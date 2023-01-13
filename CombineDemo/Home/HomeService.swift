//
//  HomeService.swift
//  CombineDemo
//
//  Created by  on 13/01/23.
//

import Foundation
import Combine

class HomeService: ServiceProtocol {
    var baseURL: String = "https://apps.agentur-loop.com/challenge"
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
}
