//
//  User.swift
//  Chess
//
//  Created by david crooks on 11/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

public struct User:Codable {
    let id:Int
    let name:String
    let rating:Float
    let type:PlayerType
}

extension User {
    public static func david() -> User {
        User(id: 1, name: "David", rating: 1200, type:.appUser)
    }
    static func chewbacka() -> User {
         User(id: 2, name: "Chewbacka", rating: 1390, type:.remote)
    }
    static func computer() -> User {
         User(id: 2, name: "R2D2", rating: 1390, type:.computer)
    }
}



struct Players {
    let white:User
    let black:User
       
   func player(for color:PlayerColor) -> User {
       switch color {
       case .white:
           return white
       case .black:
           return black
       }
   }
}
enum PlayerType:String,Codable {
    case none
    case appUser
    case remote  //gamecenter
    case computer
}
struct PlayerTypes:Codable,Equatable {
    let white:PlayerType
    let black:PlayerType
    
    public func player(for color:PlayerColor) -> PlayerType {
        switch color {
        case .white:
            return white
        case .black:
            return black
        }
    }
}

extension Players {
    static func dummys()-> Players {
        Players(white: User.david(), black: User.computer())
    }
}

func getUsers(callback:([User]) -> ()) {
    
    let users = [
        User(id: 321, name: "Jimbob", rating: 1200,type:.remote),
        User(id: 32, name: "Han Solo", rating: 1345,type:.remote),
        User(id: 78, name: "R2D2", rating: 1456,type:.computer),
        User(id: 2, name: "Chewbacka", rating: 890,type:.remote),
        User(id: 46, name: "Helmut", rating: 678,type:.remote),
        User(id: 103, name: "Tracy", rating: 1109,type:.remote)
    ]
    
    callback(users)
}



