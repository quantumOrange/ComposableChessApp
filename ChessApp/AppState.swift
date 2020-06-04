//
//  GameState.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import ChessEngine


struct AppState {
    var user = User.david()
    
   // var chessGame:ChessGameState = ChessGameState()
    
    
    var selectedSquare:ChessboardSquare?
    
    var playerPointOfView:PlayerColor = .white
    
}






