//
//  HotelTableViewCell.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/19/21.
//

import UIKit

protocol FavouriteActionDelegate: class {
    func favouriteButtonTapped(of cell:HotelTableViewCell)
}

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var hotelRatingsView: RatingsView!
    
    weak var delegate: FavouriteActionDelegate?
    
    @objc func favouriteImageTapped() {
        delegate?.favouriteButtonTapped(of: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelRatingsView.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favouriteImageTapped))
        tapGesture.delegate = self
        self.favouriteImageView.isUserInteractionEnabled = true
        self.favouriteImageView.addGestureRecognizer(tapGesture)
    }

    func setHotelWith(hotelObject:Hotel) {
        self.hotelImageView.image = hotelObject.image
        self.hotelNameLabel.text = hotelObject.name
        self.favouriteImageView.image = hotelObject.isFavourite ? UIImage(named: FavouriteImage.filled.rawValue) : UIImage(named: FavouriteImage.empty.rawValue)
        
        self.hotelRatingsView.showRatings(with: hotelObject.ratings)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
