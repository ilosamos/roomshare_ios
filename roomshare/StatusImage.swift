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
    var roomStatus : RoomStatus = RoomStatus.Free {
        didSet {
            if roomStatus == RoomStatus.Free {
                self.image = #imageLiteral(resourceName: "free")
            }
            else {
                self.image = #imageLiteral(resourceName: "full")
            }
        }
    }
}


