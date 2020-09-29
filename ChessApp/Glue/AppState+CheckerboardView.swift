//
//  AppState+CheckerboardView.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import CheckerboardView
import SwiftUI

extension AppState
{
    var chessboardState:CheckerboardState<ChessGameState>
    {
        get
        {
              CheckerboardState(game: chessGame,
                                turn: chessGame.board.whosTurnIsItAnyway.checkerboardColor ,
                                boardState: boardstate ,
                                userPlaysWhite: chessGame.players.appUser == .white,
                                userPlaysBlack: chessGame.players.appUser == .black,
                                checkerColors:CheckerColors( dark: AppColorScheme.insetInsetBackgroundColor, highlight:Color.yellow))
            
        }
        set
        {
              boardstate = newValue.boardState
              chessGame  = newValue.game
        }
    }
}
