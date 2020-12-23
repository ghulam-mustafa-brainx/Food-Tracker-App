//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by BrainX IOS 4 on 2020-12-14.
//

import UIKit
import os.log

class MealTableViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet var tableView: UITableView!
    var meals = [Meal]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = editButtonItem

        loadData()
    }

    
    // MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier){
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "showDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else{
                fatalError("Unexpected Controller: \(segue.destination)")
            }
            guard let mealTableViewCell = sender as? MealTableViewCell else{
                fatalError("Unexpected Cell: \(sender ?? "")")
            }
            guard let indexPath = tableView.indexPath(for: mealTableViewCell) else{
                fatalError("Selected cell is not in table.")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let NewIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [NewIndexPath], with: .automatic)
            }
            
            saveMeals()
        }
    }
    
    //MARK: -Private Methods
    private func loadData(){
        
        if let savedMeals = getMeals(){
            meals += savedMeals
        }else{
            loadSampleMeals()
        }
    }
    
    private func loadSampleMeals(){
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(mealName: "Fried Fish", mealRating: 4, mealImage: photo1) else {
            fatalError("Unable to initialize Meal1")
        }
        guard let meal2 = Meal(mealName: "Egg Fried Rice", mealRating: 3, mealImage: photo2) else {
            fatalError("Unable to initialize Meal1")
        }
        guard let meal3 = Meal(mealName: "Long Potato Chips", mealRating: 5, mealImage: photo3) else {
            fatalError("Unable to initialize Meal1")
        }
        
        meals += [meal1, meal2, meal3]
        
    }

    private func getMeals() -> [Meal]?{
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveUrl.path) as? [Meal]
    }
    
    public func saveMeals(){
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path)
        
        if isSuccessfulSave {
            print("Meals saved successfully.")
        }else{
            print("Failed to save data.")
        }
    }
}

//MARK: -Extensions
extension MealTableViewController: UITableViewDelegate{
    
    //MARK: -Edit Button methods
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {}
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MealTableViewController: UITableViewDataSource{
    
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
        
        cell.labelMealName.text = meal.mealName
        cell.ratingControl.rating = meal.mealRating
        cell.mealImage.image = meal.mealImage
        
        return cell
    }
}
