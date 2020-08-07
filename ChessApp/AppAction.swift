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

enum AppAction {
    case chess(ChessAction)
    case selection(CheckerboardAction)
    // case nav(NavAction)
    // case gameCenter(GameCenterAction)
    // case clock(ChessClockAction)
}


