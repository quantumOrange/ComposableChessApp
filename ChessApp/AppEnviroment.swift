//
//  AppEnviroment.swift
//  ChessApp
//
//  Created by David Crooks on 04/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import CheckerboardView
import ChessEngine
import ComposableArchitecture
import CAGameCenter

struct AppEnviroment {
    let chessEnviroment = CheckerboardEnviroment<ChessGameState>(requestMove:
    {   game in
       
        let effect = Effect<CheckerboardAction<ChessGameState>, Never>.future
        {   callback in
            DispatchQueue.global(qos: .background).async
            {

                var newGame = game
                
                if let move = pickMove(for: game.board),
                    let board = apply(move:move, to:game.board)
                {
                    newGame.board = board
                }

                // Go back to the main thread to update the UI
                DispatchQueue.main.async
                {
                    callback(.success(CheckerboardAction.setGame(newGame)))
                }
            }
              
        }
        
        return effect
    })
    
    let gameCenterClient = GameCenterClient<Chessboard>()
}


extension Chessboard:TwoPlayerGame {
    public func currentPlayerTurn() -> Player {
        return .local //???
    }
}
