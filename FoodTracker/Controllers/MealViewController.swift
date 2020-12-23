//
//  MealViewController.swift
//  FoodTracker
//
//  Created by BrainX IOS 4 on 2020-12-14.
//
import UIKit
import os.log

class MealViewController: UIViewController{

    //MARK: -Outlets
    @IBOutlet weak var tfMealName: UITextField!
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: -Properties
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfMealName.delegate = self
        setMeal()
        updateSavedButtonStatus()
    }
    
    //MARK: -Actions
    @IBAction func selectImageFromGallery(_ sender: UITapGestureRecognizer) {
        
        tfMealName.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: -Private Methods
    private func updateSavedButtonStatus(){
        
        let textField = tfMealName.text ?? ""
        saveButton.isEnabled = !textField.isEmpty
    }
    
    private func setMeal(){
        
        if let meal = meal{
            navigationItem.title = meal.mealName
            tfMealName.text = meal.mealName
            imgMeal.image = meal.mealImage
            ratingControl.rating = meal.mealRating
        }
    }
    
}

//MARK: -Delegate Extensions
extension MealViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSavedButtonStatus()
        navigationItem.title = tfMealName.text
    }
}

extension MealViewController: UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            imgMeal.image = selectedImage
            dismiss(animated: true, completion: nil)
    }
}

extension MealViewController: UINavigationControllerDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = tfMealName.text ?? ""
        let rating = ratingControl.rating
        let image = imgMeal.image
        
        meal = Meal(mealName: name, mealRating: rating, mealImage: image)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isAddMode = presentingViewController is UINavigationController
        
        if isAddMode {
            dismiss(animated: true, completion: nil)
        }else if let owingNavigationController = navigationController{
            owingNavigationController.popViewController(animated: true)
        }else{
            fatalError("MealViewController is not in Navigation.")
        }
    }
}

