//
//  StatusImage.swift
//  roomshare
//
//  Created by Daniel Berger on 14/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import Foundation
import UIKit

class StatusImage : UIImageView {
  var roomStatus : RoomStatus = .Free {
    didSet {
      animateSwitch()
      if roomStatus == .Free {
        self.image = #imageLiteral(resourceName: "free")
      }
      else {
        self.image = #imageLiteral(resourceName: "full")
      }
    }
  }
  func animateSwitch() {
    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.30)
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.37, initialSpringVelocity: 0, options: [], animations: {
      self.transform = .identity
    }, completion: nil)
  }
}


