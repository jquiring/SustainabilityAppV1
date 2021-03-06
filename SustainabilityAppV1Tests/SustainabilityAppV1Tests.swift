//
//  SustainabilityAppV1Tests.swift
//  SustainabilityAppV1Tests
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import XCTest

class SustainabilityAppV1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testIsNeumeric(){
        var n = NewUserController()
        XCTAssert(n.isNumeric("3"), "GOOD")
    }
    
    func testIsNeumericFalse(){
        var n = NewUserController()
        XCTAssertFalse(n.isNumeric("a"), "GOOD")
    }
    
    func testIsNeumericDouble(){
        var n = NewUserController()
        XCTAssertFalse(n.isNumeric("3.0"), "GOOD")
    }
    
   
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
