//
//  Hotel_AddTableViewController.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/19/21.
//

import UIKit

class Hotel_AddTableViewController: UITableViewController {
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    var selectedHotel:Hotel?
    
    var hotelViewType:HotelViewType = .add_hotel {
        didSet {
            updateHotelInfoState()
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateOfStayTextField: UITextField!
    @IBOutlet weak var roomRateTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var ratingStackView: RatingsView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.setupNavigationBar()
        self.setupView()
        
        //Set Datepicker as inputView
        self.dateOfStayTextField.setInputViewDatePicker(target: self, selector: #selector(doneButtonTapped))
        
        self.roomRateTextField.addDoneButtonOnKeyboard(target: self, selector: #selector(doneButtonTapped))
        
        self.ratingStackView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedHotel == nil {
            selectedHotel = Hotel(id: 0,
                          name: "",
                          address: "",
                          dateOfStay: Date(),
                          roomRate: 0,
                          ratings: 0,
                          image: UIImage(named: "addImage")!,
                          isFavourite: false)
        }
    }
    
    //MARK:- Initial setup
    private func registerNib() {
        let headerNib = UINib.init(nibName: "Hotel_HeaderImageView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "Hotel_HeaderImageView")
        
        let footerNib = UINib.init(nibName: "Hotel_FooterView", bundle: Bundle.main)
        tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "Hotel_FooterView")
    }
    
    private func setupNavigationBar() {
        switch self.hotelViewType {
        case .add_hotel:
            navigationItem.title = NSLocalizedString("Add Hotel", comment: "")
            navigationItem.rightBarButtonItem  = nil
        case .edit_hotel,.detail_hotel:
            navigationItem.title = selectedHotel?.name
            navigationItem.rightBarButtonItem = editBarButton
        }
    }
    
    
    private func setupView() {
        if let hotel = selectedHotel {
            self.nameTextField.text = hotel.name
            self.addressTextField.text = hotel.address
            self.dateOfStayTextField.text = self.stringFrom(date: hotel.dateOfStay)
            self.roomRateTextField.text = String(hotel.roomRate)
            self.ratingStackView.showRatings(with: hotel.ratings)
        }
    }
    
    //MARK:- Date Picker
    @objc func doneButtonTapped() {
        if let datePicker = self.dateOfStayTextField.inputView as? UIDatePicker {
            self.selectedHotel?.dateOfStay = datePicker.date
            self.dateOfStayTextField.text = self.stringFrom(date: datePicker.date)
        }
        self.dateOfStayTextField.resignFirstResponder()
    }
    
    //MARK:- Input Validations
    func validateInputField()  -> Bool {
        var isTextFieldsValid = true
        
        for textField in [nameTextField, addressTextField, dateOfStayTextField, roomRateTextField] {
            isTextFieldsValid = isTextFieldValid(textField: textField!)
            if !isTextFieldsValid {
                break
            }
        }
        return isTextFieldsValid
    }
    
    func isTextFieldValid(textField:UITextField) -> Bool {
        if let inputText = textField.text, !inputText.isEmpty {
            return true
        }
        return false
    }
    
    func showAlertforInputs() {
        let alertViewController = UIAlertController.init(title: NSLocalizedString("Alert", comment: ""), message: "Please fill all the details", preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { (action) in
            print("Ok Button tapped")
        }
        
        alertViewController.addAction(okButtonAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func updateHotelInfoState() {
        self.tableView.isUserInteractionEnabled = true
        if self.hotelViewType == .detail_hotel {
            self.tableView.isUserInteractionEnabled = false
        }
        self.ratingStackView.showRatings(with: selectedHotel!.ratings)
        self.tableView.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        self.hotelViewType = .edit_hotel
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewConstants.headerViewHeight.rawValue
        }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Hotel_HeaderImageView") as! Hotel_HeaderImageView
        headerView.delegate = self
        if let hotel = selectedHotel {
            headerView.setImageView(with: hotel.image)
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        //Hide Update button when View is presented in Detail
        if self.hotelViewType == .detail_hotel {
            return nil
        }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Hotel_FooterView") as! Hotel_FooterView
        footerView.setDoneButtonTitle(with: self.hotelViewType)
        footerView.delegate = self
        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.hotelViewType == .detail_hotel {
            return 0
        }
        return tableViewConstants.footerViewHeight.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewConstants.rowHeight.rawValue
    }
    
    //MARK:- Date methods
    func dateFrom(str:String) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        if let formattedDate = dateformatter.date(from: str) {
            return formattedDate
        }
        return nil
    }
    
    func stringFrom(date:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        return dateformatter.string(from: date)
    }
}

extension Hotel_AddTableViewController: PhotoActionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func addHotelImage() {
        self.showImageOptions()
    }
    
    //Show alert to select the media source type.
    private func showImageOptions() {
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect =  CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //Take Image using Camera
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: false, completion: nil)
        }
    }

    //Fetch image from Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.selectedHotel?.image = image
            self?.tableView.reloadData()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension Hotel_AddTableViewController: HotelActionDelegate {
    
    func actionButtonTapped() {
        self.view.endEditing(true)

        let isInputValid = validateInputField()
        if isInputValid {
            if self.hotelViewType == .edit_hotel {
                HotelListViewModel.update(hotel: selectedHotel!)
            } else {
                let hotelId = Int.random(in: 0...1000)
                selectedHotel?.id = hotelId
                HotelListViewModel.add(hotel: selectedHotel!)
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showAlertforInputs()
        }
    }
}

extension Hotel_AddTableViewController: RatingActionDelegate {
    func ratingProvided(with value: Int) {
        selectedHotel?.ratings = value
    }
}

extension Hotel_AddTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            selectedHotel?.name = textField.text!
        } else if textField == addressTextField {
            selectedHotel?.address = textField.text!
        } else if textField == roomRateTextField {
            let price:Int = Int(textField.text!) ?? 0
            selectedHotel?.roomRate = price
        }
    }
}

