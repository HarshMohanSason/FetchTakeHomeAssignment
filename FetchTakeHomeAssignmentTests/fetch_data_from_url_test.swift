//
//  FetchTakeHomeAssignmentTests.swift
//  FetchTakeHomeAssignmentTests
//
//  Created by Harsh Mohan Sason on 12/4/24.
//

import XCTest
@testable import FetchTakeHomeAssignment

final class FetchTakeHomeAssignmentTests: XCTestCase {

    var fetchDataFromTheUrl: FetchDataFromTheUrl!

     override func setUpWithError() throws {
         fetchDataFromTheUrl = FetchDataFromTheUrl()
     }

     override func tearDownWithError() throws {
         fetchDataFromTheUrl = nil
     }
     
     func testFetchDataFunction() async {
         //expectation for when the data is fetched
         let expectation = XCTestExpectation(description: "Data fetched successfully")

         await fetchDataFromTheUrl.fetchData()
         
         //If recipeItems is not [], expectation is fulfilled
         if !fetchDataFromTheUrl.recipeItems.isEmpty {
             expectation.fulfill()
         }

         //wait for the fulfillment of the expectation
         await fulfillment(of: [expectation], timeout: 10)

         XCTAssertGreaterThan(fetchDataFromTheUrl.recipeItems.count, 0, "recipeItems should be populated with at least one item.")
     }

}
