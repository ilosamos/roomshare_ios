//
//  Utility.swift
//  roomshare
//
//  Created by Daniel Berger on 21/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit

class Utility {
  // Shows simple alert Message with OK Button
  class func showAlertMessage(title: String, message: String,_ vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    DispatchQueue.main.async {
      vc.present(alert, animated: true, completion: nil)
    }
  }
  
  // Fades in all views in order of the views in the given array
  class func fadeInViews(_ views: [UIView], index: Int = 0) {
    guard index < views.count else {
      return
    }
    UIView.animate(withDuration: 0.05, animations: {
      views[index].alpha = 1
    }) { (true) in
      Utility.fadeInViews(views, index: index + 1)
    }
  }
  
  // Overload for fade in views with variadic parameters
  class func fadeInViews(_ views: UIView...) {
    Utility.fadeInViews(views)
  }
}

enum RoomStatus : Int {
  case Full = 1
  case Free = 0
  case Unknown = -1
}
