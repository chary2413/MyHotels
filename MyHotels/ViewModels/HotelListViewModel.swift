//
//  HotelListViewModel.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/19/21.
//

import Foundation

class HotelListViewModel {
    static var hotels = [Hotel]()
    
    static func add(hotel:Hotel?) {
        if let hotelModel = hotel {
            self.hotels.append(hotelModel)
        }
    }
    
    static func update(hotel:Hotel) {
        if let currentHotelIndex = self.hotels.firstIndex(where: {$0.id == hotel.id}) {
            self.hotels[currentHotelIndex] = hotel
        }
    }
    
    static func remove(hotel:Hotel) {
        if let currentHotelIndex = self.hotels.firstIndex(where: {$0.id == hotel.id}) {
            self.hotels.remove(at: currentHotelIndex)
        }
    }
    
    static func listHotels() -> [Hotel] {
        return self.hotels
    }
}


