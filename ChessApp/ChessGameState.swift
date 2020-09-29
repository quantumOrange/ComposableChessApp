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
    
    func color(of playerType:PlayerType) -> PlayerColor? {
         white == playerType ? .white : (black == playerType ? .black : nil)
    }
    
    var appUser:PlayerColor? { color(of: .appUser)}
    var remotePlayer:PlayerColor? {color(of: .remote) }
    var computer:PlayerColor? { color(of: .computer) }
}

struct ChessGameState:Equatable {
    var inPlay:Bool { board.gamePlayState == .inPlay }
    var board:Chessboard =  Chessboard.start()
    var players:PlayerTypes = PlayerTypes(white:.none, black: .none)
    
    var gameOver:GameOver? = nil
    init() {}
    
}

extension ChessGameState:Codable {
    private enum CodingKeys: String, CodingKey {
        case board, players
    }
}


