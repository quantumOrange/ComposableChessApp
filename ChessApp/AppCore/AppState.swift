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
let user = User.david()
struct AppState: Equatable {
   // var user = User.david()
    var nav:NavState  = NavState()
    var chessGame:ChessGameState = ChessGameState()
    var boardstate:CheckerBoardUIState = CheckerBoardUIState(defaultPOV: .white)
   
    var gameCenterMatchState:GameCenterMatchState = GameCenterMatchState()
    
    
}




