//
//  TodayViewController.swift
//  roomShareWidget
//
//  Created by Daniel Berger on 11/04/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusSwitch: UISwitch!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
      
      let defaults = UserDefaults(suiteName: "group.com.berger.roomshare")
      defaults?.synchronize()
      
      // Check for null value before setting
      if let status = defaults?.integer(forKey: "roomStatus") {
        if status == 0 {
          statusLabel.text = "Room is currently free!";
        }
        else if status == 1 {
          statusLabel.text = "Room is currently occupied!";
        }
        else {
          statusLabel.text = "";
        }
      }
      else {
        print("Cannot find value")
      }
      
      print("did perform update")
      
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
