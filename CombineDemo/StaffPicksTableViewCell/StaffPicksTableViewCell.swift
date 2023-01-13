//
//  StaffPicksTableViewCell.swift
//  LoopNewMedia
//
//  Created by  on 31/10/22.
//

import UIKit
import Combine

class StaffPicksTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet private weak var posterImageView: ImageViewWithCache?
    @IBOutlet private weak var bookmarkImageView: UIImageView?
    @IBOutlet private weak var movieTitleLabel: UILabel?
    @IBOutlet private weak var movieReleaseYearLabel: UILabel?
    @IBOutlet private weak var movieRatingView: StarsView?
    
    var celldata: StaffPicksViewModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private let eventSubject = PassthroughSubject<StaffPicksViewModel, Never>()
    var eventPublisher: AnyPublisher<StaffPicksViewModel, Never> {
      eventSubject.eraseToAnyPublisher()
    }

    var cancellables = Set<AnyCancellable>()
    
    @objc private func bookmarkImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let celldata = celldata {
            eventSubject.send(celldata)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bookmarkImageTapped(tapGestureRecognizer:)))
        bookmarkImageView?.isUserInteractionEnabled = true
        bookmarkImageView?.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      cancellables = Set<AnyCancellable>()
    }
    
    private func configureCell() {
        posterImageView?.loadImage(urlString: celldata?.posterImageURL)
        movieTitleLabel?.text = celldata?.movieTitle
        movieReleaseYearLabel?.text = celldata?.movieReleaseYear
        movieRatingView?.rating = celldata?.ratings ?? 0
        bookmarkImageView?.image = (UserDefaultDataManager.shared.retriveBookMarks().contains(celldata?.id ?? 0) ) ? UIImage(named: "BookmarkFill") : UIImage(named: "Bookmark")
    }
    
}
