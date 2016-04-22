//
//  UserViewModelTest.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/17/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import XCTest
@testable import RACTDC2016

class UserViewModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSaveUser() {
        let successExpectation: XCTestExpectation = self.expectationWithDescription("SuccessExpectation")
        let failureExpectation: XCTestExpectation = self.expectationWithDescription("FailureExpectation")
        
        let userViewModel: UserViewModel = UserViewModel()
        
        userViewModel.username.value = "Skywalker"

        userViewModel.saveUser().on(
            completed: {
                successExpectation.fulfill()
            }, failed: { error in
                XCTFail()
        }).start()

        userViewModel.username.value = "Darth Vader"
        
        userViewModel.saveUser().on(
            completed: {
                XCTFail()
            }, failed: { error in
                failureExpectation.fulfill()
        }).start()
        
        self.waitForExpectationsWithTimeout(10) { error in
            if error != nil {
                XCTFail()
            }
        }
        
    }

}
