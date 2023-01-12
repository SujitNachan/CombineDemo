//
//  MovieTableViewDelegate.swift
//  CombineDemo
//
//  Created by  on 11/01/23.
//

import UIKit
import Combine

class MovieTableViewDelegate: NSObject, UITableViewDelegate {
    private var cancellables = Set<AnyCancellable>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeViewSections.ourStaff.rawValue {
//            interactor?.staffPicksDidSelect(staffPicksViewModel: staffPicks[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let boldfont = UIFont.SFProDisplay(.bold, size: 12) else {
            return nil
        }
        switch section {
        case HomeViewSections.searchButton.rawValue:
            let headerView = HeaderViewWithButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 48))
            headerView.searchButtonTapped.sink { [unowned self] in
                
            }.store(in: &cancellables)
//            headerView.searchButtonTapped = { [unowned self] in
//                self.interactor?.routeToSearchScreen()
//            }
            return headerView
            
        case HomeViewSections.yourFavorites.rawValue:
            let headerWithLabel = HeaderViewWithLabel(title: "YOUR FAVORITES", titleFont: UIFont.SFProDisplay(.regular, size: 12), textToChange: "FAVORITES", fontToChange: boldfont)
            return headerWithLabel
            
        case HomeViewSections.ourStaff.rawValue:
            let headerWithLabel = HeaderViewWithLabel(title: "OUR STAFF PICKS", titleColor: .white, titleFont: UIFont.SFProDisplay(.regular, size: 12), textToChange: "STAFF PICKS", fontToChange: boldfont)
            return headerWithLabel
            
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case HomeViewSections.searchButton.rawValue:
            return 48
        default:
            return 25
        }
    }
}
