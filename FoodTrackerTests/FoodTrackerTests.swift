//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by BrainX IOS 4 on 2020-12-14.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Meal Class Test Code
    //Test in scuccess case
    func testMealInitializationScceed(){
        //Zero Rating
        let zeroRatingMeal = Meal.init(mealName: "Zero", mealRating: 0, mealImage: nil)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Highest Positive Rating
        let positiveRating = Meal.init(mealName: "Positive", mealRating: 5, mealImage: nil)
        XCTAssertNotNil(positiveRating)
    }
    
    //Test in failed case
    func testMealInitializationFail(){
        //Empty meal name
        let emptyMealName = Meal.init(mealName: "", mealRating: 0, mealImage: nil)
        XCTAssertNil(emptyMealName)
        
        //Negative rating
        let negativeRating = Meal.init(mealName: "Negative", mealRating: -2, mealImage: nil)
        XCTAssertNil(negativeRating)
        
        //Exceeds max rating
        let maxRatingExceeds = Meal.init(mealName: "Exceeds rating", mealRating: 8, mealImage: nil)
        XCTAssertNil(maxRatingExceeds)
    }

}
