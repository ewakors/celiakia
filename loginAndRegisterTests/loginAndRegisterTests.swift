//
//  loginAndRegisterTests.swift
//  loginAndRegisterTests
//
//  Created by Ewa Korszaczuk on 18.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import XCTest
@testable import loginAndRegister

class loginAndRegisterTests: XCTestCase {
    
    var login: LoginViewController = LoginViewController()
    
    override func setUp() {
        super.setUp()
        login.passwordTxt.text = "useruser" 
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
