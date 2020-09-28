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
import CAGameCenter

let chessboardReducer = Reducer<CheckerboardState<ChessGameState>, CheckerboardAction, CheckerboardEnviroment> (checkerBoardReducer)
let gameCenterReducer = Reducer<GameCenterState<Chessboard>,GameCenterClientAction<Chessboard>,GameCenterEnviroment> (gameReducer)

let appReducer: Reducer<AppState, AppAction, Enviroment> = Reducer.combine(
    chessGameReducer.pullback(state: \.chessGame, action: /AppAction.chessGame, environment:  { $0.chessGameEnviroment } ),
    chessboardReducer.pullback(state: \.chessboardState, action: /AppAction.checkerboard , environment: { $0.chessboardEnviroment }),
    navReducer.pullback(state: \.nav, action: /AppAction.nav, environment: { _ in }),
    gameCenterReducer.pullback(state: \.gameCenterState, action: /AppAction.gameCenter, environment:{ $0.gameCenterEnviroment })
)

