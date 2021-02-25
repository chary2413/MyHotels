//
//  Hotel_Enums.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/22/21.
//

import Foundation
import CoreGraphics

enum HotelViewType {
    case add_hotel
    case edit_hotel
    case detail_hotel
}

enum FavouriteImage: String {
    case empty = "emptyFav"
    case filled = "filledFav"
}

enum tableViewConstants: CGFloat {
    case headerViewHeight = 140
    case footerViewHeight = 100
    case rowHeight = 60
}


