//
//  FirstViewControllerTest.swift
//  roomshare
//
//  Created by Daniel Berger on 08/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import XCTest
@testable import roomshare
import Firebase

class FirstViewControllerTest: XCTestCase {
  let app_delegate = UIApplication.shared.delegate
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    let viewController = storyboard.instantiateInitialViewController() as! FirstViewController
    let view = viewController.view
    XCTAssertNotNil(view, "Cannot find View")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
