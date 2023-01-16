//
//  ViewController.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    var movieTableView: UITableView?
    private var cancellables = Set<AnyCancellable>()
    private var movieTableViewDelegate = MovieTableViewDelegate()
    private var movieTableViewDataSource: MovieTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        movieTableViewDataSource.fetchData()
        movieTableViewDataSource.observeHomeDataModel()
    }
    
    private func setupUI() {
        movieTableView = UITableView(frame: self.view.bounds, style: .grouped)
        movieTableView?.separatorStyle = .none
        if let movieTableView = movieTableView {
            self.view.addSubview(movieTableView)
        }
        movieTableView?.backgroundColor = .clear
        movieTableView?.delegate = movieTableViewDelegate
        let movieTableViewDataSourceObj = MovieTableViewDataSource(homeViewModel: HomeViewModel(homeService: HomeServiceImplementation()))
        movieTableViewDataSource = movieTableViewDataSourceObj
        movieTableView?.dataSource = movieTableViewDataSource
        movieTableView?.register(StaffPicksTableViewCell.self)
        movieTableView?.register(TableViewCellWithCollectionView.self)
        
        movieTableViewDataSource.reloadTableSubject.sink { [weak self] in
            self?.movieTableView?.reloadData()
        }.store(in: &cancellables)
    }
}
