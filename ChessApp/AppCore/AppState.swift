//
//  GameState.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import ChessEngine
import CheckerboardView
import CAGameCenter

struct AppState: Equatable {
   
    var nav:NavState  = NavState()
    var chessGame:ChessGameState = ChessGameState()
    var boardstate:CheckerBoardUIState = CheckerBoardUIState(defaultPOV: .white)
    var gameCenterMatchState:GameCenterMatchState = GameCenterMatchState()
    
    var user = PlayerDetails.defaultUser
    var remote = PlayerDetails.remoteUser
    var computer = PlayerDetails.computer
}




