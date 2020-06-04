//
//  PlayerColor.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation

public enum PlayerColor:Int,Equatable,Codable {
    case white
    case black
}

public prefix func !(v:PlayerColor)-> PlayerColor {
    switch v {
    case .white:
        return .black
    case .black:
        return .white
    }
}
