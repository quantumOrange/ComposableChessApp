//
//  ChessEngine+Checkerboard.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import CheckerboardView
import ChessEngine

extension ChessEngine.PlayerColor {
    var checkerboardColor: CheckerboardView.PlayerColor {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}
