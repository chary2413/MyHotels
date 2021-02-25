//
//  Hotel_HeaderImageView.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/21/21.
//

import UIKit

protocol PhotoActionDelegate: class {
    func addHotelImage()
}

class Hotel_HeaderImageView: UITableViewHeaderFooterView {

    
    weak var delegate: PhotoActionDelegate?
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.imageView.image = UIImage(named: "addImage")
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.delegate?.addHotelImage()
    }
    
    func setImageView(with image:UIImage) {
        imageView.image = image
    }
}
