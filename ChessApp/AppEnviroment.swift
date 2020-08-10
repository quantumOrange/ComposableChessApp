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



struct AppEnviroment {
    let chessEnviroment = CheckerboardEnviroment<ChessGameState>(requestMove: {game in
        if let move = pickMove(for: game.board),
            let board = apply(move:move, to:game.board) {
            var newGame = game
            newGame.board = board
            print("Created new game")
            return Effect(value: CheckerboardAction.setGame(newGame))
        }
        return Effect.none
    })
    /*
    let checkerboardEnviroment = CheckerboardEnviroment(playMove: { move in
        
        return Effect(value: .clear)
    }, selected: { square in
        return Effect(value: .validDestinationSquares([]))
    })

    let chessEnviroment = ChessEnviroment(pickMove: { board in
        let move = pickMove(for:board)
        //DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            if let move = move {
                return Effect<ChessAction,Never>(value: .chessMove(move))
                //callback(.endo(.chessMove(move)))
            }
            else {
                return Effect<ChessAction,Never>(value: .noValidMoves)
                //callback(.endo(.noValidMoves))
            }
       // }
       // return Effect(value: .)
    }, sendTurn: { board in
        Effect.none
    }
    )
   */
}
