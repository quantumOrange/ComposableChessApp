//
//  ChessGameReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import ChessEngine
import CheckerboardView
import ComposableArchitecture
//let placedPieces = chessGame.board.positionPieces.map { PlacedCheckerPiece(piece: $0.1, square: $0.0.boardSquare) }

extension AppState {
    //CheckerboardState(placedPieces: chessGame.board.positionPieces.map { PlacedCheckerPiece(piece: $0.1, square: $0.0.boardSquare)
    var chessboardState:CheckerboardState<ChessGameState> {
        get { CheckerboardState(game: chessGame, turn: chessGame.board.whosTurnIsItAnyway.checkerboardColor , boardState: boardstate ) }
        set { boardstate = newValue.boardState
            chessGame = newValue.game
        }
    }
}

let chessboardReducer = Reducer<CheckerboardState<ChessGameState>, CheckerboardAction, CheckerboardEnviroment> (checkerBoardReducer)

let appReducer: Reducer<AppState, AppAction, AppEnviroment> = Reducer.combine(
    chessboardReducer.pullback(state: \.chessboardState, action: /AppAction.chess , environment: { enviroment in enviroment.chessEnviroment })
   // chessReducer.pullback(state: \.chessGame, action:/AppAction.chess,environment: { enviroment in enviroment.chessEnviroment })

)

/*
let appReducer:Reducer<AppState, AppAction> = combineReducers(
        pullback( navReducer,                    value:\.nav,                   action: \.nav),
        pullback( loggedChessReducer,            value:\.chessGame,             action: \.chess,         f:pulbackChessEnviromentAction  ),
        pullback( chessboardUIReducer,           value:\.selectedSquareState,   action: \.selection,     f:pullbackSelectionEA           ),
        pullback( logging(gameCenterReducer),    value:\.gameCenter,            action: \.gameCenter,    f:pullbackGamecenterEA          ),
        pullback( chessClockReducer,             value:\.clocks,                action: \.clock,         f:pullbackClockExoAction        )
    )
*/
