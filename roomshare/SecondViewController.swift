//
//  SecondViewController.swift
//  roomshare
//
//  Created by Daniel Berger on 14/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
                Utility.showAlertMessage(title: "Error", message: error.localizedDescription, self)
                return
        }
        Utility.showAlertMessage(title: "Bye!", message: "You are now signed out", self)
    }
}

