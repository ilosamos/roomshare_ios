//
//  FirstViewController.swift
//  roomshare
//
//  Created by Daniel Berger on 14/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit
import CoreData
import FirebaseInstanceID
import FirebaseAuthUI
import Firebase

class FirstViewController: UIViewController, FUIAuthDelegate {
  @IBOutlet weak var statusImage: StatusImage!
  @IBOutlet weak var submitButton: SwitchButton!
  @IBOutlet weak var statusLabel: StatusLabel!
  
  var roomStatus = RoomStatus.Unknown {
    didSet {
      updateViews()
    }
  }
  
  var handle: FIRAuthStateDidChangeListenerHandle?
  var auth: FIRAuth? = FIRAuth.auth()
  var user: FIRUser!
  var refRoom : FIRDatabaseReference!
  var refStatus : FIRDatabaseReference!
  var refCurrentUser: FIRDatabaseReference!
  var refUserTokens: FIRDatabaseReference!
  
  //User id of user entering or leaving room
  var uidIn: String!
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    self.refStatus.removeAllObservers()
    self.refCurrentUser.removeAllObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //Handle authentication
    handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
      if user == nil {
        let authUI = FUIAuth.init(uiWith: FIRAuth.auth()!)
        authUI?.delegate = self
        
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
      }
      else {
        self.user = user
        print("user equals user")
        //Subscribe user to room
        self.refRoom.child("follower/\(self.user.uid)").setValue(true)
        //Observe the room status
        self.refStatus.observe(.value, with: self.statusChanged)
        self.refCurrentUser.observe(.value, with: self.currentUserChanged)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set databse references
    refStatus = FIRDatabase.database().reference(withPath: "rooms/room1/status")
    refCurrentUser = FIRDatabase.database().reference(withPath: "rooms/room1/currentUser")
    refRoom = FIRDatabase.database().reference(withPath: "rooms/room1")
    
    NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
  }
  
  //Required protocol method for FIRAuthUIDelegate
  public func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
    guard error == nil else {
      Utility.showAlertMessage(title: "Error", message: error!.localizedDescription, self)
      return
    }
    self.user = user
    updateViews()
    Utility.showAlertMessage(title: "Success", message: "Welcome \(user!.displayName!)", self)
    refUserTokens = FIRDatabase.database().reference(withPath: "users/\(user!.uid)/notificationTokens")
    writeFcmToken()
  }
  
  //Status Changed Observer Function
  func statusChanged (snapshot: FIRDataSnapshot) -> Void {
    print("called status changed")
    guard let val = snapshot.value else {
      print("status changed value null")
      return
    }
    roomStatus = RoomStatus(rawValue: val as? Int ?? -1)!
  }
  
  //User Changed Observer Functions
  func currentUserChanged (snapshot: FIRDataSnapshot) -> Void {
    guard let val = snapshot.value else {
      return
    }
    
    uidIn = val as? String ?? "unknown"
  }
  
  //update UI Views
  func updateViews() {
    DispatchQueue.main.async {
      self.statusImage.roomStatus = self.roomStatus
      self.submitButton.roomStatus = self.roomStatus
      self.statusLabel.roomStatus = self.roomStatus
    }
  }
  
  //Called when FCM token is received
  func tokenRefreshNotification(_ notification: Notification) {
    guard FIRInstanceID.instanceID().token() != nil else {
      return
    }
    writeFcmToken()
    print("FCM refreshed")
  }
  
  
  //Write FCM Token to database
  func writeFcmToken () {
    guard let token = FIRInstanceID.instanceID().token() else {
      print("no token?")
      return
    }
    print("FCM Token: \(token)")
    refUserTokens.child(token).setValue(true)
  }
  
  //Button Clicked to set the room full or empty
  @IBAction func switchClicked(_ sender: Any) {
    print("switch clicked! uid: \(user.uid)")
    print("Current room status: \(roomStatus.rawValue)")
    
    print("Current USer: \(uidIn)")
    
    switch roomStatus {
    case .Full:
      guard user.uid == uidIn else {
        Utility.showAlertMessage(title: "Error", message: "Not allowed!", self)
        return
      }
      refStatus.setValue(RoomStatus.Free.rawValue)
      refCurrentUser.setValue(user.uid)
    case .Free:
      refStatus.setValue(RoomStatus.Full.rawValue)
      refCurrentUser.setValue(user.uid)
    default:
      refStatus.setValue(RoomStatus.Unknown.rawValue)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

