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

class FirstViewController: UIViewControllerB, FUIAuthDelegate {
  @IBOutlet weak var statusImage: StatusImage!
  @IBOutlet weak var submitButton: SwitchButton!
  @IBOutlet weak var statusLabel: StatusLabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var changeStatusLabel: UILabel!
  @IBOutlet weak var backgroundBlur: UIVisualEffectView!
  @IBOutlet weak var messageTextField: UITextFieldB!
  
  var handle: FIRAuthStateDidChangeListenerHandle?
  var auth: FIRAuth? = FIRAuth.auth()
  var refRoom : FIRDatabaseReference!
  var refStatus : FIRDatabaseReference!
  var refCurrentUser: FIRDatabaseReference!
  var refUserTokens: FIRDatabaseReference!
  var refRoomName: FIRDatabaseReference!
  
  var roomStatus: RoomStatus = .Unknown {
    didSet {
      updateViews()
    }
  }
  
  // When user is set, create references
  var user: FIRUser! {
    didSet {
      refUserTokens = FIRDatabase.database().reference(withPath: "users/\(user!.uid)/notificationTokens")
      refRoom.child("follower/\(self.user.uid)").setValue(true)
    }
  }
  
  // Is populated when Token is refreshed
  var refreshedToken: String?
  
  // User id of user entering or leaving room
  var uidIn: String!
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    self.refStatus.removeAllObservers()
    self.refCurrentUser.removeAllObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Handle authentication
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
        print("User is authenticated.")
        // Observe roomStatus and currentUser
        self.refCurrentUser.observe(.value, with: self.currentUserChanged)
        self.refStatus.observe(.value, with: self.statusChanged)
        self.refRoomName.observe(.value, with: self.roomNameChanged)
        self.writeFcmToken()
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Utility.fadeInViews(titleLabel,statusLabel,statusImage,changeStatusLabel,submitButton)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    setViewsInvisible()
  }
  
  // Set alpha of views of given array to 0
  func setViewsInvisible() {
    titleLabel.alpha = 0; statusLabel.alpha = 0; statusImage.alpha = 0; changeStatusLabel.alpha = 0; submitButton.alpha = 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Prepare Views for fade in
    setViewsInvisible()
    
    // Set databse references
    refStatus = FIRDatabase.database().reference(withPath: "rooms/room1/status")
    refCurrentUser = FIRDatabase.database().reference(withPath: "rooms/room1/currentUser")
    refRoom = FIRDatabase.database().reference(withPath: "rooms/room1")
    refRoomName = FIRDatabase.database().reference(withPath: "rooms/room1/name")
    
    NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
  }
  
  // Required protocol method for FIRAuthUIDelegate
  public func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
    guard error == nil else {
      Utility.showAlertMessage(title: "Error", message: error!.localizedDescription, self)
      return
    }
    self.user = user
    updateViews()
    Utility.showAlertMessage(title: "Success", message: "Welcome \(user!.displayName!)", self)
    writeFcmToken()
  }
  
  // Called when status of room is changed in DB
  func statusChanged (snapshot: FIRDataSnapshot) -> Void {
    print("called status changed")
    guard let val = snapshot.value else {
      print("status changed value null")
      return
    }
    roomStatus = RoomStatus(rawValue: val as? Int ?? -1)!
    
    //Save status to UserDefaults for widget extension
    let defaults = UserDefaults(suiteName: "group.com.berger.roomshare")
    defaults?.setValue(roomStatus.rawValue, forKey: "roomStatus")
    defaults?.synchronize()
  }
  
  func roomNameChanged (snapshot: FIRDataSnapshot) -> Void {
    guard let name = snapshot.value as? String else { return }
    titleLabel.text = name
  }
  
  // Called when currentUser is changed in DB
  func currentUserChanged (snapshot: FIRDataSnapshot) -> Void {
    guard let val = snapshot.value else {
      return
    }
    
    uidIn = val as? String ?? "unknown"
  }
  
  // Update Views according to roomStatus
  func updateViews() {
    DispatchQueue.main.async {
      self.statusImage.roomStatus = self.roomStatus
      self.submitButton.roomStatus = self.roomStatus
      self.statusLabel.roomStatus = self.roomStatus
    }
  }
  
  // Called when FCM token is received
  func tokenRefreshNotification(_ notification: Notification) {
    guard FIRInstanceID.instanceID().token() != nil else {
      return
    }
    writeFcmToken()
    print("FCM refreshed")
  }
  
  
  // Write FCM Token to database
  func writeFcmToken () {
    guard let token = FIRInstanceID.instanceID().token() else {
      print("no token?")
      return
    }
    print("FCM Token: \(token)")
    
    // If not already authenticated store Token in variable
    if user == nil {
      refreshedToken = token
    }
    else {
      refUserTokens.child(token).setValue(true)
      refreshedToken = nil
    }
    
  }
  
  // Button Clicked to set the room full or empty
  @IBAction func switchClicked(_ sender: Any) {
    print("switch clicked! uid: \(user.uid)")
    print("Current room status: \(roomStatus.rawValue)")
    
    print("Current USer: \(uidIn)")
    
    switch roomStatus {
    case .Full,.Free:
      if user.uid != uidIn && roomStatus == .Full {
        Utility.showAlertMessage(title: "Error", message: "Not allowed!", self)
        return
      }
      refStatus.setValue(roomStatus.rawValue ^ 1)
      refCurrentUser.setValue(user.uid)
    default:
      refStatus.setValue(RoomStatus.Unknown.rawValue)
    }
  }
  @IBAction func messageTextEditingDidBegin(_ sender: UITextField) {

  }
  @IBAction func messageTextFieldDone(_ sender: UITextFieldB) {
    messageTextField.resignFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

