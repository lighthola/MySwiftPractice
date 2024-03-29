//
//  OVOPatternLockUITests.swift
//  OVOPatternLockUITests
//
//  Created by Bevis Chen on 2017/5/15.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import XCTest

class OVOPatternLockUITests: XCTestCase {
        
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
    
    
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let coord1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.15))
        let coord2 = coord1.withOffset(CGVector(dx: 100, dy: 100))
        
        coord1.press(forDuration: 1, thenDragTo: coord2)
        
        let coord3 = coord2.withOffset(CGVector(dx: 200, dy: 0))
        coord2.press(forDuration: 1, thenDragTo: coord3)
        let coord4 = coord3.withOffset(CGVector(dx: 0, dy: 200))
        coord3.press(forDuration: 1, thenDragTo: coord4)
        
    }
    
}
