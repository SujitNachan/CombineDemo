//
//  HomeViewModel.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import Foundation
import Combine

class HomeDataModel: ObservableObject {
    let movies: [Movie]
    let staffPicks: [Movie]
    
    init(movies: [Movie], staffPicks: [Movie]) {
        self.movies = movies
        self.staffPicks = staffPicks
    }
    
    var staffPicksViewModels: [StaffPicksViewModel] {
        staffPicks.map({ StaffPicksViewModel(id: $0.id, posterImageURL: $0.posterUrl, movieTitle: $0.title, movieReleaseYear: $0.releaseDate, ratings: $0.rating) })
    }
    
    var favoriteMovieViewModels: [FavoriteMovieViewModel] {
        movies.map({FavoriteMovieViewModel(id: $0.id, imageURL: $0.posterUrl, primaryText: nil, secondaryText: nil)})
    }
}

class HomeViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    @Published var homeDataModel: HomeDataModel?
    
    func getHomeData() {
        getPublisher(endpoint: .movies, type: Movie.self).sink { [weak self] completion in
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] movies in
            self?.homeDataModel = HomeDataModel(movies: movies, staffPicks: self?.homeDataModel?.staffPicks ?? [])
        }
        .store(in: &cancellable)
        
        getPublisher(endpoint: .staffPicks, type: Movie.self).sink { [weak self] completion in
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] movies in
            self?.homeDataModel = HomeDataModel(movies: self?.homeDataModel?.movies ?? [], staffPicks: movies)
        }
        .store(in: &cancellable)
    }
    
    func getPublisher<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> {
        NetworkManager.shared.getData(endpoint: endpoint, type: type)
    }
    
    func bookmark(staffPick: StaffPicksViewModel) {
        if let id = staffPick.id {
            UserDefaultDataManager.shared.retriveBookMarks().contains(id) ? UserDefaultDataManager.shared.removeBookmark(id: id) : UserDefaultDataManager.shared.addBookmark(id: id)
        }
    }
}
