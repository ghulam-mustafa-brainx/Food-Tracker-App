//
//  TableViewDataSource.swift
//  FoodTracker
//
//  Created by BrainX IOS 4 on 2020-12-22.
//

import UIKit

public class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -Properties
    var meals = [Meal]()
    
    
    // MARK: - Table view data source
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        
        cell.label_mealName.text = meal.mealName
        cell.ratingControl.rating = meal.mealRating
        cell.img_mealImage.image = meal.mealImage
        
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {}
    }
    
    public func saveMeals(){
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path)
        
        if isSuccessfulSave {
            print("Meals saved successfully.")
        }else{
            print("Failed to save data.")
        }
    }//saveMeals
}
