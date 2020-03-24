//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Samuel Wang on 3/21/20.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by MealTableViewController in prepare(for:sender) or constructed as part of adding a new meal
     */
    var meal: Meal?
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_textField: UITextField) {
        // disable save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePIckerControllerDidCancel(_picker: UIImagePickerController) {
        // dismiss picker if user cancels
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info dictionary may contain multiple representations of an image. want to use the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_sender: UIBarButtonItem) {
        // depending on style of presentation (modal/push), this view controller needs ot be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if (isPresentingInAddMealMode) { // adding meal
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController { // edit existing meal
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // configure destination view controller only when user presses save button
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // hide keyboard if user taps on photo
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // only allows photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // setup views if editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // enable save button only if the text field has a valid meal name
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // disable save button if text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

