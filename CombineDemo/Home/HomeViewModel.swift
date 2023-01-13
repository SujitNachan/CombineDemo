//
//  HomeViewModel.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import Foundation
import Combine

protocol HomeDataModelProtocol {
    var movies: [Movie] { get set }
    var staffPicks: [Movie] { get set }
}

extension HomeDataModelProtocol {
    var staffPicksViewModels: [StaffPicksViewModel] {
        staffPicks.map({ StaffPicksViewModel(id: $0.id, posterImageURL: $0.posterUrl, movieTitle: $0.title, movieReleaseYear: $0.releaseDate, ratings: $0.rating) })
    }
    
    var favoriteMovieViewModels: [FavoriteMovieViewModel] {
        movies.map({FavoriteMovieViewModel(id: $0.id, imageURL: $0.posterUrl, primaryText: nil, secondaryText: nil)})
    }
}

class HomeViewModel: ObservableObject, HomeDataModelProtocol {
    var movies: [Movie] = []
    var staffPicks: [Movie] = []
    private var cancellable = Set<AnyCancellable>()
    private var homeService: ServiceProtocol
    
    var homeViewModelChanageSubject = PassthroughSubject<HomeViewModel,Never>()
    
    init(homeService: ServiceProtocol) {
        self.homeService = homeService
    }
    
    func getHomeData() {
        getPublisher(endpoint: .movies, type: Movie.self).sink { completion in
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] movies in
            guard let self = self else { return }
            self.movies = movies
            self.homeViewModelChanageSubject.send(self)
        }
        .store(in: &cancellable)
        
        getPublisher(endpoint: .staffPicks, type: Movie.self).sink { completion in
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] movies in
            guard let self = self else { return }
            self.staffPicks = movies
            self.homeViewModelChanageSubject.send(self)
        }
        .store(in: &cancellable)
    }
    
    func getPublisher<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> {
        homeService.getData(endpoint: endpoint, type: type)
    }
    
    func bookmark(staffPick: StaffPicksViewModel) {
        if let id = staffPick.id {
            UserDefaultDataManager.shared.retriveBookMarks().contains(id) ? UserDefaultDataManager.shared.removeBookmark(id: id) : UserDefaultDataManager.shared.addBookmark(id: id)
        }
    }
}
