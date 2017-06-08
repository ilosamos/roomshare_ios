//
//  roomshareTests.swift
//  roomshareTests
//
//  Created by Daniel Berger on 14/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import XCTest
@testable import roomshare
import Firebase

class roomshareTests: XCTestCase {
  var vc : RoomVC!
  var testRoomStatusRef : FIRDatabaseReference!
  var testRoomUserRef : FIRDatabaseReference!
  
  override func setUp() {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    vc = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! RoomVC
    
    testRoomStatusRef = FIRDatabase.database().reference(withPath: "rooms/testRoom/status")
    testRoomUserRef = FIRDatabase.database().reference(withPath: "rooms/testRoom/currentUser")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // Test if RooomStatus is correclty received and set in ViewController
  func testStatusChanged() {
    let expect = expectation(description: "Status successfully changed")
    
    testRoomStatusRef.observe(.value, with: {(snapshot) in
      self.vc.statusChanged(snapshot: snapshot)
      expect.fulfill()
    })
    
    waitForExpectations(timeout: 5.0, handler: {(_) in
      print(expect.description)
      XCTAssertNotEqual(RoomStatus.Unknown.rawValue, self.vc.roomStatus.rawValue)
    })
  }
  
  // Test if User is correctly received and set in ViewController
  func testCurrentUserChanged() {
    let expect = expectation(description: "User successfully set")
    var mockUser = ""
    
    testRoomUserRef.observe(.value, with: {(snapshot) in
      self.vc.currentUserChanged(snapshot: snapshot)
      mockUser = snapshot.value as! String
      expect.fulfill()
    })
    
    waitForExpectations(timeout: 5.0, handler: {(_) -> Void in
      print(expect.description)
      print("MockUser: \(mockUser), DBUser: \(self.vc.uidIn)")
      XCTAssertEqual(mockUser, self.vc.uidIn)
    })
  }
  
  // Test if RoomStatus is correctly switched after clicking button
  func testSwitchClicked() {
    let expect = expectation(description: "RoomStatus successfully switched")
    let oldStatus = vc.roomStatus
    
    // Set References in ViewController to TestRoom
    vc.refStatus = testRoomStatusRef
    vc.refCurrentUser = testRoomUserRef
    
    vc.switchClicked("Test")
    
    let newStatus = vc.roomStatus
    
    print("old status: \(oldStatus), new Status: \(newStatus)")
  }
  
  // Test Utility function to fade in views
  func testFadeInViews() {
    let view = UIView()
    view.alpha = 0
    
    // Test with empty array
    Utility.fadeInViews([])
    
    // Test with one element
    Utility.fadeInViews([view])
    XCTAssertGreaterThan(view.alpha, 0)
    
    // Test with 2 elements
    view.alpha = 0
    Utility.fadeInViews([view,view])
    XCTAssertGreaterThan(view.alpha, 0)
  }
}
