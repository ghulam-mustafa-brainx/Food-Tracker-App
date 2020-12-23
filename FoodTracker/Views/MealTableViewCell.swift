//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by BrainX IOS 4 on 2020-12-14.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    //MARK: -Outlets
    @IBOutlet weak var labelMealName: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
