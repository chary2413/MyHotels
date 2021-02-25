//
//  ViewController.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/19/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyLabel: UILabel!
    
    var hotels = [Hotel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func updateView() {
        hotels = HotelListViewModel.listHotels()
        if !hotels.isEmpty {
            self.emptyLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        } else {
            self.emptyLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    func navigateToDetailViewController(with hotel:Hotel) {
        let hotelDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Hotel_AddTableViewControllerID") as! Hotel_AddTableViewController
        hotelDetailViewController.selectedHotel = hotel
        hotelDetailViewController.hotelViewType = .detail_hotel
        self.navigationController?.pushViewController(hotelDetailViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotelCell:HotelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! HotelTableViewCell
        hotelCell.setHotelWith(hotelObject: self.hotels[indexPath.row])
        hotelCell.delegate = self
        return hotelCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigateToDetailViewController(with: self.hotels[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK:- Delegate for Delete option
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.tableView.beginUpdates()
            HotelListViewModel.remove(hotel: self.hotels[indexPath.row])
            self.hotels.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.endUpdates()
        }
    }
}

extension ViewController: FavouriteActionDelegate {
    func favouriteButtonTapped(of cell: HotelTableViewCell) {
        if let rowIndexPath = tableView.indexPath(for: cell) {
            var hotel = HotelListViewModel.listHotels()[rowIndexPath.row]
            if hotel.isFavourite == true {
                hotel.isFavourite = false
            } else {
                hotel.isFavourite = true
            }
            HotelListViewModel.update(hotel: hotel)
            self.hotels = HotelListViewModel.listHotels()
            self.tableView.reloadRows(at: [rowIndexPath], with: .none)
        }
        
    }
}
