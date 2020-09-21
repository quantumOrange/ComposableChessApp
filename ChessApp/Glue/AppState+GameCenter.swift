//
//  AppState+GameCenter.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import CAGameCenter

extension AppState {
    var gameCenterState:GameCenterState<Chessboard>{
        get {GameCenterState(game:chessGame.board,matchState:gameCenterMatchState,localPlayerDisplayName: "mR local",remotePlayerDisplayName: "mr remote" )}
        
        set {
            gameCenterMatchState = newValue.matchState
            chessGame.board = newValue.game
        }
    }
}
