//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Samuel Wang on 3/22/20.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // create button
            let button = UIButton()
            
            // set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to stack
            addArrangedSubview(button)
            
            // add button to ratingButtons array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // calculate rating of selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // if selected star represents current rating, reset rating to 0
            rating = 0
        } else {
            // otherwise, set rating to selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // select all buttons whose indices are less than current rating
            button.isSelected = index < rating
            
            // set hint string for currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // assign hint and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
