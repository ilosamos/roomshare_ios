//
//  DraggableUITextField.swift
//  roomshare
//
//  Created by Daniel Berger on 13/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

class DraggableUITextField: UITextFieldB {

  var hiddenCenter: CGPoint!
  var shownCenter: CGPoint!
  var lastCenter: CGPoint!
  
  @IBInspectable var animationSpeed: TimeInterval = 0.1
  
  var isShown: Bool = false {
    didSet {
      if isShown {
        shownCenter = center
        lastCenter = shownCenter
      }
      else {
        hiddenCenter = center
        lastCenter = hiddenCenter
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    hiddenCenter = self.center
    shownCenter = self.center
    
    let pan = UIPanGestureRecognizer(target: self.superview, action: #selector(handlePan))
    self.addGestureRecognizer(pan)
  }
  
  // MARK: Pan Gesture
  func handlePan(sender: UITapGestureRecognizer) {
    print("handlePan called")
  }
  
  // MARK: Show/Hide Animations
  
  func setHidden(animated: Bool) {
    setHidden(animated: animated, duration: animationSpeed)
  }
  
  // Set textfield to hidden position
  func setHidden(animated: Bool, duration: TimeInterval) {
    resignFirstResponder()
    
    if animated {
      UIView.animate(withDuration: duration, animations: {
        self.center = self.hiddenCenter
        self.isShown = false
      })
    }
    else {
      center = hiddenCenter
      isShown = false
    }
  }
  
  // Set textfield centered to view
  func setShown(animated: Bool, inView view: UIView) {
    if animated {
      UIView.animate(withDuration: animationSpeed, animations: {
        self.center = CGPoint(x: view.center.x, y: self.lastCenter.y)
        self.isShown = true
      })
    }
    else {
      center = shownCenter
      isShown = true
    }
  }
  
  // Reset textfield to last position wheter shown or hidden
  func setLastCenter(animated: Bool) {
    if animated {
      UIView.animate(withDuration: animationSpeed, animations: {
        self.center = self.lastCenter
      })
    }
    else {
      center = lastCenter
    }
  }
  
  // Sets textfield center to bottom, typically used while editing
  func setBottom(animated: Bool, inView view: UIView) {
    if animated {
      UIView.animate(withDuration: animationSpeed, animations: { 
        self.center = CGPoint(x: self.center.x, y: view.frame.height - self.frame.height)
      })
    }
    else {
      self.center = CGPoint(x: self.center.x, y: view.frame.height - self.frame.height)
    }
  }
}
