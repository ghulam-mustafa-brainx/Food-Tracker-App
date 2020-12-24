//
//  MealViewController.swift
//  FoodTracker
//
//  Created by BrainX IOS 4 on 2020-12-14.
//
import os.log
import UIKit

class MealViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: Properties
    var meal: Meal?
    
    //MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealName.delegate = self
        setMeal()
        updateSavedButtonStatus()
    }
    
    //MARK: Actions
    @IBAction
    func selectImageFromGallery(_ sender: UITapGestureRecognizer) {
        mealName.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSavedButtonStatus() {
        let textField = mealName.text ?? ""
        saveButton.isEnabled = !textField.isEmpty
    }
    
    private func setMeal() {
        if let meal = meal {
            navigationItem.title = meal.mealName
            mealName.text = meal.mealName
            mealImage.image = meal.mealImage
            ratingControl.rating = meal.mealRating
        }
    }
    
}

//MARK: UITextFieldDelegate Methods
extension MealViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSavedButtonStatus()
        navigationItem.title = mealName.text
    }
}

//MARK: UIImagePickerControllerDelegate Methods
extension MealViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            mealImage.image = selectedImage
            dismiss(animated: true, completion: nil)
    }
}

//MARK: UINavigationControllerDelegate Methods
extension MealViewController: UINavigationControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = mealName.text ?? ""
        let rating = ratingControl.rating
        let image = mealImage.image
        
        meal = Meal(mealName: name, mealRating: rating, mealImage: image)
    }
    
    @IBAction
    func cancel(_ sender: UIBarButtonItem) {
        let isAddMode = presentingViewController is UINavigationController
        
        if isAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owingNavigationController = navigationController {
            owingNavigationController.popViewController(animated: true)
        } else {
            fatalError("MealViewController is not in Navigation.")
        }
    }
}

