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
protocol HomeViewModelInterface {
    func fetchMovies(endPoint: String)
    func fetchStaffPicks(endPoint: String)
}


class HomeViewModel: ObservableObject, HomeDataModelProtocol, HomeViewModelInterface {
    var movies: [Movie] = []
    var staffPicks: [Movie] = []
    var cancellable = Set<AnyCancellable>()
    private var homeService: HomeServiceInterface
    
    var homeViewModelChanageSubject = PassthroughSubject<HomeViewModel,Never>()
    var errorSubject = PassthroughSubject<Error,Never>()
    
    init(homeService: HomeServiceInterface) {
        self.homeService = homeService
    }
    
    func fetchMovies(endPoint: String) {
        homeService.fetchMovies(endPoint: endPoint)
        .receive(on: RunLoop.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            if case let .failure(error) = completion {
                print("Error -> \(error.localizedDescription) \(endPoint)")
                self.errorSubject.send(error)
            }
        } receiveValue: { [weak self] newMovies in
            guard let self = self else { return }
            self.movies = newMovies
            self.homeViewModelChanageSubject.send(self)
        }
        .store(in: &cancellable)
    }
    
    func fetchStaffPicks(endPoint: String) {
        homeService.fetchMovies(endPoint: endPoint)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    print("Error -> \(error.localizedDescription) \(endPoint)")
                    self.errorSubject.send(error)
                }
            } receiveValue: { [weak self] newMovies in
                guard let self = self else { return }
                self.staffPicks = newMovies
                self.homeViewModelChanageSubject.send(self)
            }
            .store(in: &cancellable)
    }
    
    func bookmark(staffPick: StaffPicksViewModel) {
        if let id = staffPick.id {
            UserDefaultDataManager.shared.retriveBookMarks().contains(id) ? UserDefaultDataManager.shared.removeBookmark(id: id) : UserDefaultDataManager.shared.addBookmark(id: id)
        }
    }
}
