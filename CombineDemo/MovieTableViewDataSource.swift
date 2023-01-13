//
//  MovieTableViewDataSource.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import UIKit
import Combine

enum HomeViewSections: Int, CaseIterable {
    case searchButton
    case yourFavorites
    case ourStaff
}

protocol MovieTableViewDataSourceProtocol: UITableViewDataSource {
    var staffPicks: [StaffPicksViewModel] { get set }
    var movies: [FavoriteMovieViewModel] { get set }
    
    var reloadTableSubject: PassthroughSubject<Void,Never> { get set }
    
    func observeHomeDataModel()
    func fetchData()
    
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

extension MovieTableViewDataSourceProtocol {
    var cellSize: CGSize {
        CGSize(width: UIScreen.main.bounds.height*0.21, height: UIScreen.main.bounds.height*0.31)
    }
}

class MovieTableViewDataSource: NSObject, MovieTableViewDataSourceProtocol {
    var staffPicks: [StaffPicksViewModel] = []
    var movies: [FavoriteMovieViewModel] = []
    var cancellables = Set<AnyCancellable>()
    var homeViewModel: HomeViewModel
    
    var reloadTableSubject = PassthroughSubject<Void,Never>()

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    func fetchData() {
        self.homeViewModel.getHomeData()
    }
    
    private func update(homeDataModel: HomeDataModel) {
        self.staffPicks = homeDataModel.staffPicksViewModels
        self.movies = homeDataModel.favoriteMovieViewModels
    }
    
    func observeHomeDataModel() {
        homeViewModel.$homeDataModel.sink { [weak self] homeDataModel in
            guard let self = self,
            let homeDataModel = homeDataModel else { return }
            self.update(homeDataModel: homeDataModel)
            self.reloadTableSubject.send()
        }
        .store(in: &cancellables)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeViewSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case HomeViewSections.searchButton.rawValue:
            return 0
        case HomeViewSections.ourStaff.rawValue:
            return staffPicks.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case HomeViewSections.ourStaff.rawValue:
            let staffCell: StaffPicksTableViewCell =  tableView.dequeueReusableCell(for: indexPath)
            staffCell.celldata = self.staffPicks[indexPath.row]
            staffCell.eventPublisher
                .sink { [weak self, indexPath] staffPick in
                    guard let self = self else { return }
                    self.homeViewModel.bookmark(staffPick: staffPick)
                    UIView.performWithoutAnimation {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
            }.store(in: &staffCell.cancellables)
            return staffCell
            
        default:
            let movieCell: TableViewCellWithCollectionView = tableView.dequeueReusableCell(for: indexPath)
            movieCell.configuation = FavoriteMovieCellConfiguration(cellData: self.movies, footerSize: cellSize, itemSize: cellSize)
//            movieCell.didSelectHandlerSubject.sink { [unowned self] yourFavoriteMovie in
//                
//            }.store(in: &cancellables)
//            movieCell.didSelectHandler = { [unowned self] yourFavoriteMovie in
////                self.interactor?.movieDidSelect(yourFavoriteMovieViewModel: yourFavoriteMovie)
//            }
            return movieCell
        }
    }
}
