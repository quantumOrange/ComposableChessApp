//
//  User.swift
//  ChessApp
//
//  Created by David Crooks on 29/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import UIKit

struct PlayerDetails:Equatable {
    var displayName:String
    var image:UIImage?
}


extension PlayerDetails {
    static var defaultUser:PlayerDetails =  PlayerDetails(displayName: "You!", image: UIImage(named:"defaultUser"))
    static var computer:PlayerDetails =  PlayerDetails(displayName: "Computer", image: UIImage(named:"defaultComputer"))
    static var remoteUser:PlayerDetails =  PlayerDetails(displayName: "Remote", image:  UIImage(named:"defaultUser"))
}
