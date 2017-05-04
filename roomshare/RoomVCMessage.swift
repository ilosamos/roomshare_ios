//
//  RoomVCMessage.swift
//  roomshare
//
//  Created by Daniel Berger on 13/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension RoomVC: UITextFieldDelegate {
  
  // Respond to pan gesture
  func textFieldPan(_ sender: UIPanGestureRecognizer) {
    guard let textField = sender.view as? DraggableUITextField else { return }
    
    if sender.state == .began && !textField.isShown {
      textField.isShown = false
    }
    
    // Only swipeable if textfield is not editing
    if !textField.isEditing {
      let point = sender.translation(in: view)
      textField.center = CGPoint(x: textField.lastCenter.x + point.x, y: textField.lastCenter.y)
      
      if sender.state == .ended && !textField.isShown {
        if point.x < (textField.frame.width / 5) * -1 {
          messageTextField.setShown(animated: true, inView: self.view)
        }
        else {
          messageTextField.setLastCenter(animated: true)
        }
      }
      else if sender.state == .ended && textField.isShown {
        if point.x > textField.frame.width / 5 {
          messageTextField.setHidden(animated: true)
        }
        else {
          messageTextField.setLastCenter(animated: true)
        }
      }
    }
  }
  
  // Prevent user from editing when not allowed
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    print("isCurrentUser: \(isCurrentUser)")
    print("roomStatus: \(roomStatus)")
    
    if isCurrentUser && roomStatus == .Full {
      messageTextField.tintColor = UIColor.clear
      return true
    }
    else {
      Utility.showAlertMessage(title: "Nope", message: "Message can only be set when the room is blocked by you", self)
      return false
    }
  }
  
  // Save Message
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    refMessage.setValue(text)
  }
  
  // Respond to message value change in database
  func messageChanged (snapshot: FIRDataSnapshot) -> Void {
    guard let message = snapshot.value as? String else { return }
    messageTextField.text = message
    messageTextField.setHidden(animated: true)
    
    if !isCurrentUser && roomStatus == .Full {
      messageTextField.tintColor = UIColor.clear
      messageTextField.leftImage = #imageLiteral(resourceName: "exclamation")
    }
    else {
      messageTextField.tintColor = UIColor.clear
      messageTextField.leftImage = #imageLiteral(resourceName: "pencil")
    }
  }
}
