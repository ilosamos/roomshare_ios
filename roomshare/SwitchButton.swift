//
//  switchButton.swift
//  roomshare
//
//  Created by Daniel Berger on 15/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import Foundation
import UIKit

class SwitchButton : UIButton {
    var roomStatus : RoomStatus = RoomStatus.Free {
        didSet {
            if roomStatus == RoomStatus.Free {
                self.setTitle("I'm currently rehearsing!", for: UIControlState.normal)
                self.isEnabled = true
            }
            else {
                self.setTitle("Just finished rehearsal!", for: UIControlState.normal)
                self.isEnabled = true
            }
        }
    }
}
