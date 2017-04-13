//
//  UITextFieldB.swift
//  roomshare
//
//  Created by Daniel Berger on 12/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

@IBDesignable class UITextFieldB: UITextField {
  
  // MARK: Border and Corner
  @IBInspectable var borderWidth: CGFloat = 0.0 {
    didSet {
      self.layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var borderColor: UIColor = .clear {
    didSet {
      self.layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  // MARK: - Left View
  @IBInspectable var leftImage: UIImage? {
    didSet {
      updateLeftView()
    }
  }
  
  @IBInspectable var leftPadding: CGFloat = 0.0 {
    didSet {
      updateLeftView()
    }
  }
  
  // MARK: - Misc
  @IBInspectable var placeholderColor: UIColor? {
    didSet {
      guard let color = placeholderColor else { return }
      attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName: color])
    }
  }
  
  func updateLeftView() {
    guard let image = leftImage else { return }
    leftViewMode = .always
    
    var width = leftPadding + 20
    
    if borderStyle == .none || borderStyle == .line {
      width = width + leftPadding
    }
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
    let button = UIButton(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
    button.setBackgroundImage(image, for: .normal)
    button.tintColor = tintColor
    button.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
    
    view.addSubview(button)
    leftView = view
  }
  
  func leftButtonPressed(button: UIButton) {
    print("Button Pressed")
  }
}
