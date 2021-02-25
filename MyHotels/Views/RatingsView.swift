//
//  RatingsView.swift
//  MyHotels
//
//  Created by Shanmukeshwara Chary on 2/21/21.
//

import UIKit

protocol RatingActionDelegate: class {
    func ratingProvided(with value:Int)
}

class RatingsView: UIStackView {
    
    weak var delegate: RatingActionDelegate?
    private var ratingButtons = [UIButton]()
    var starSize: CGSize = CGSize(width: 25.0, height: 25.0)
    var starCount = 5
    var hotelRating:Int?
    
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    convenience init(with ratings:Int) {
        self.init()
        self.hotelRating = ratings
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
        self.delegate?.ratingProvided(with: selectedRating)
    }
    
    private func setupButtons() {
        
        // Load Button Images
        let emptyStar = UIImage(named: "emptyStar")
        let filledStar = UIImage(named: "filledStar")
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingsView.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
    }
    
    private func updateButtonSelectionStates() {
        self.showRatings(with: rating)
    }
      
    
    func showRatings(with rating:Int) {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }

}
