//
//  Utility.swift
//  roomshare
//
//  Created by Daniel Berger on 21/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

//Wrapper for alert messages
class Utility {
  class func showAlertMessage(title: String, message: String,_ vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    DispatchQueue.main.async {
      vc.present(alert, animated: true, completion: nil)
    }
  }
}

enum RoomStatus : Int {
  case Full = 1
  case Free = 0
  case Unknown = -1
}
