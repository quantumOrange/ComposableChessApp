//
//  AppAction.swift
//  Chess
//
//  Created by David Crooks on 17/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import ChessEngine
import CheckerboardView
import CAGameCenter

enum AppAction {
    case chessGame(ChessGameAction)
    case checkerboard(CheckerboardAction)
    case nav(NavAction)
    case gameCenter(GameCenterClientAction<Chessboard>)
    case explore(ExploreAction)
}




