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
    var user = User.david()
    var nav:NavState  = NavState()
    var chessGame:ChessGameState = ChessGameState()
    
    var boardstate:BoardState = BoardState()
    
    var playerPointOfView:CheckerboardView.PlayerColor = .white
    
    var gameCenterMatchState:GameCenterMatchState = GameCenterMatchState()
}

extension AppState {
    var gameCenterState:GameCenterState<Chessboard>{
        get {GameCenterState(game:chessGame.board,matchState:gameCenterMatchState,localPlayerDisplayName: "mR local",remotePlayerDisplayName: "mr remote" )}
        
        set {
            gameCenterMatchState = newValue.matchState
            chessGame.board = newValue.game
        }
        
    }
}


