//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Samuel Wang on 3/21/20.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    //MARK: Meal Class Tests
    func testMealInitializationSucceeds() {
        // zero rating
        let zeroRatingMeal = Meal.init(name: "zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // highest positive rating
        let positiveRatingMeal = Meal.init(name: "positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    func testMealInitializationFails() {
        // negative rating
        let negativeRatingMeal = Meal.init(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // empty string
        let emptyStringMeal = Meal.init(name:"", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
        let largeRatingMeal = Meal.init(name: "large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }

}
