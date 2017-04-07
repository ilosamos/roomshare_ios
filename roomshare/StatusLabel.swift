//
//  StatusLabel.swift
//  roomshare
//
//  Created by Daniel Berger on 15/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import Foundation
import UIKit

class StatusLabel : UILabel {
    var roomStatus : RoomStatus = RoomStatus.Free {
        didSet {
            if roomStatus == RoomStatus.Free {
                self.text = "Free!"
            }
            else {
                self.text = "Occupied!"
            }
        }
    }
}
