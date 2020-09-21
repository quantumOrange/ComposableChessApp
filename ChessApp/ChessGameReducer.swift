//
//  ChessGameReducer.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture
import ChessEngine

enum ChessGameAction {
    case subscribe
    case clear
    case chessMove(ChessMove)
    case move(Move)
    case resign(PlayerColor)
    case timeout(PlayerColor)
    case offerDraw(PlayerColor)
    case noValidMoves
    case nextTurn
    case playBothSides(Chessboard?)
    case playComputerAs(PlayerColor,Chessboard?)
    case setOnlineGame(Chessboard,PlayerColor)
}


protocol ChessGameEnviromentProtocol {
    func didSuccefullyApplyMove() -> Effect<ChessGameAction,Never>
    func sendTurnToGameCenter(board:Chessboard) -> Effect<ChessGameAction,Never>
    func chessEnginePickMove(board:Chessboard) -> Effect<ChessGameAction,Never>
    func subscribeToApplication() -> Effect<ChessGameAction,Never>
}

func requestNextTurn(game:ChessGameState, enviroment:ChessGameEnviromentProtocol) -> Effect<ChessGameAction,Never> {
    let playerType =  game.players.player(for:game.board.whosTurnIsItAnyway)
    
    switch playerType {
    case .none:
        //Mabe fatal error? what should we do here?
        print("Player type none! probaly bad")
        
        return Effect.none
    case .appUser:
        //wait for user, nothing to do here
        print("It is now the local players turn, so we just need to wait for them to do something.")
        return Effect.none
    case .remote:
        print("We must have just applied the local players move.")
        print("It is now the remote players turn, as far as we  are concerned.")
        print("We need to send the board to the gamecenter and pass  the turn to them.")

        return enviroment.sendTurnToGameCenter(board: game.board)
    case .computer:
        //let board = game.board
        return enviroment.chessEnginePickMove(board: game.board)
    }
}



let chessGameReducer = Reducer<ChessGameState, ChessGameAction, ChessGameEnviromentProtocol>
{ game, action, enviroment in
    
    switch action {
           
       case .chessMove(let move):
            if(applyMoveIfValid(board:&game.board, move:move))
            {
                return enviroment
                            .didSuccefullyApplyMove()
                            .merge(with:requestNextTurn(game: game, enviroment: enviroment))
                            .eraseToEffect()
            }
    
       case .move(let move):
            if(applyMoveIfValid(board:&game.board, move:move))
            {
                return enviroment
                            .didSuccefullyApplyMove()
                            .merge(with:requestNextTurn(game: game, enviroment: enviroment))
                            .eraseToEffect()
            }
       case .nextTurn:
           return requestNextTurn(game: game, enviroment: enviroment)
       case .offerDraw(_):
           game.board.gamePlayState = .draw
       case .resign(let player):
           game.board.gamePlayState = .won(!player)
       case .noValidMoves:
           game.board.gamePlayState = .draw
       case .timeout(let player):
           game.board.gamePlayState = .won(!player)
       case .setOnlineGame(let chessboard, let localPlayer):
           print("Setting the game to:")
           print(chessboard)
           game.board = chessboard
          // chessboard.moves.count.isMultiple(of: 2)
           switch localPlayer {
           case .white:
               game.players =   PlayerTypes(white: .appUser, black: .remote)
           case .black:
               game.players =  PlayerTypes(white:.remote, black: .appUser)
           }
          
           game.gameHasBegun = true
           
           
       case .playComputerAs(let playerColor, let board ):
           game.board = board ?? Chessboard.start()
           //var effect
           switch playerColor {
           
           case .white:
               game.players = PlayerTypes(white: .appUser, black: .computer)
           case .black:
               game.players = PlayerTypes(white: .computer, black: .appUser)
               return requestNextTurn(game: game, enviroment: enviroment)
           }
           
       case .playBothSides(let board):
           
           game.board = board ?? Chessboard.start()
           game.players = PlayerTypes(white: .appUser, black: .appUser)
       case .clear:
           game.board = Chessboard.start()
           game.players = PlayerTypes(white: .none, black: .none)
       case .subscribe:
           return enviroment.subscribeToApplication()
    }
    
    return Effect.none
}



