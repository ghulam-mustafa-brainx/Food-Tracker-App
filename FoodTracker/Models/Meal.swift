import os.log
import UIKit

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    var mealName: String
    var mealRating: Int
    var mealImage: UIImage?
    
    //MARK: Static properties
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentDirectory.appendingPathComponent("meals")
    
    //MARK: Struct for keys
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
    }
    
    //MARK: Initiallizers
    init?(mealName: String, mealRating: Int, mealImage: UIImage?) {
        guard !mealName.isEmpty else {
            return nil
        }
        guard (mealRating >= 0) && (mealRating <= 5) else {
            return nil
        }
        self.mealName = mealName
        self.mealRating = mealRating
        self.mealImage = mealImage
    }
    
    //MARK: NSCoding methods
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let image = coder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        self.init(mealName: name, mealRating: rating, mealImage: image)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(mealName, forKey: PropertyKey.name)
        coder.encode(mealImage, forKey: PropertyKey.image)
        coder.encode(mealRating, forKey: PropertyKey.rating)
    }
}

