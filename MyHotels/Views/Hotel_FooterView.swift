//
//  Hotel_FooterView.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/22/21.
//

import UIKit

protocol HotelActionDelegate: class {
    func actionButtonTapped()
}

class Hotel_FooterView: UITableViewHeaderFooterView {

    weak var delegate: HotelActionDelegate?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.delegate?.actionButtonTapped()
    }
    
    func setDoneButtonTitle(with screenType:HotelViewType) {
        var buttonTitle = NSLocalizedString("Add", comment: "")
        if screenType == .edit_hotel {
            buttonTitle = NSLocalizedString("Update", comment: "")
        }
        self.doneButton.setTitle(buttonTitle, for: .normal)
    }
}
