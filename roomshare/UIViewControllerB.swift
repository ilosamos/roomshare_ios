//
//  UIViewControllerB.swift
//  roomshare
//
//  Created by Daniel Berger on 13/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

class UIViewControllerB: UIViewController {
  @IBInspectable var moveViewOnKeyboardShown: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if moveViewOnKeyboardShown {
      // Observer for keyboard appearance
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowHide), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
  }
  
  // Move View up/down when keyboard is shown/hidden
  func keyboardShowHide(notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return }
    let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
    let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
    let animationOption = UIViewAnimationOptions(rawValue: curve)
    
    let keyboardFrameValue:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
    let keyboardFrame = keyboardFrameValue.cgRectValue
        
    UIView.animate(withDuration: duration, delay: 0, options: animationOption, animations: {
      if notification.name == NSNotification.Name.UIKeyboardWillShow {
        self.view.transform = CGAffineTransform(translationX: 0, y: keyboardFrame.height * -1)
      }
      else if notification.name == NSNotification.Name.UIKeyboardWillHide {
        self.view.transform = .identity
      }
    })
  }
}
