//
//  UIButtonB.swift
//  roomshare
//
//  Created by Daniel Berger on 12/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

@IBDesignable class UIButtonB: UIButton {

  // MARK: Border
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
  
  // MARK: - Corner Radius
  @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
}
