//
//  AppState+CheckerboardView.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import CheckerboardView

extension AppState {
    var chessboardState:CheckerboardState<ChessGameState> {
        get { CheckerboardState(game: chessGame, turn: chessGame.board.whosTurnIsItAnyway.checkerboardColor , boardState: boardstate ) }
        set { boardstate = newValue.boardState
            chessGame = newValue.game
        }
    }
}
