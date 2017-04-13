//
//  FirebaseTests.swift
//  roomshare
//
//  Created by Daniel Berger on 07/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import XCTest
@testable import roomshare
import Firebase

class FirebaseTests: XCTestCase {
  let firstViewController = FirstViewController()
  
  override func setUp() {
    super.setUp()
    FIRApp.configure()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // Test if database has rooms
  func testDBStructure() {
    let refDB = FIRDatabase.database().reference(withPath: "rooms")
    refDB.observe(.value, with: { (snapshot) in
      print("DB key rooms has \(snapshot.childrenCount) children.")
      XCTAssertTrue(snapshot.hasChildren())
    });
  }
  
  func testStatusChanged() {
    
  }
}
