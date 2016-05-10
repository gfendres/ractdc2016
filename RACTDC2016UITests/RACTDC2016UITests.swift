//
//  RACTDC2016UITests.swift
//  RACTDC2016UITests
//
//  Created by Guilherme Endres on 4/2/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import XCTest

class RACTDC2016UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEnterCorrectName() {
        let app = XCUIApplication()
        let textField = app.textFields["username"]
        textField.tap()
        textField.typeText("Anakin")
        app.buttons["ENTER"].tap()
        let error = app.staticTexts["error"]
        
        XCTAssert(!error.hittable)
    }
    
    func testEnterWrongName() {
        let app = XCUIApplication()
        let textField = app.textFields["username"]
        textField.tap()
        textField.typeText("Darth Vader")
        app.buttons["ENTER"].tap()
        
        let error = app.staticTexts["error"]
        
        XCTAssert(error.hittable)
    }
    
}
