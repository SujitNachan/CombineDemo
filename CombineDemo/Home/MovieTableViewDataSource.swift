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

class MovieTableViewDataSource: NSObject, UITableViewDataSource {
    var staffPicks: [StaffPicksViewModel] = []
    var movies: [FavoriteMovieViewModel] = []
    var cancellables = Set<AnyCancellable>()
    var homeViewModel: HomeViewModel
    
    var reloadTableSubject = PassthroughSubject<Void,Never>()

    var cellSize: CGSize {
        CGSize(width: UIScreen.main.bounds.height*0.21, height: UIScreen.main.bounds.height*0.31)
    }
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    func fetchData() {
        self.homeViewModel.getHomeData()
    }
    
    func observeHomeDataModel() {
        homeViewModel.homeViewModelChanageSubject.sink { [weak self] updateViewModel in
            guard let self = self else { return }
            self.homeViewModel = updateViewModel
            self.movies = self.homeViewModel.favoriteMovieViewModels
            self.staffPicks = self.homeViewModel.staffPicksViewModels
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
