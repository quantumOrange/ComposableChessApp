//
//  ChessGameState.swift
//  ChessApp
//
//  Created by David Crooks on 12/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine

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

struct ChessGameState:Equatable {
    var gameHasBegun = false
    var board:Chessboard =  Chessboard.start()
    var players:PlayerTypes = PlayerTypes(white:.none, black: .none)
    
    init() {
       // self.board = board
       // self.players = players
    }
}
