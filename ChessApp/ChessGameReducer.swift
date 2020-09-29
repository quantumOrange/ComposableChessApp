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
    case resign(PlayerColor?)
    case timeout(PlayerColor)
    case offerDraw(PlayerColor?)
    case noValidMoves
    case nextTurn
    case playBothSides(Chessboard?)
    case playComputerAs(PlayerColor,Chessboard?)
    case setOnlineGame(Chessboard,PlayerColor)
    case setGame(ChessGameState)
    case saveCurrentGame
    case load
}

protocol ChessGameEnviromentProtocol {
    func didSuccefullyApplyMove() -> Effect<ChessGameAction,Never>
    func sendTurnToGameCenter(board:Chessboard) -> Effect<ChessGameAction,Never>
    func chessEnginePickMove(board:Chessboard) -> Effect<ChessGameAction,Never>
    func subscribeToApplication() -> Effect<ChessGameAction,Never>
    func save(game:ChessGameState) -> Effect<ChessGameAction, Never>
    func load() -> Effect<ChessGameAction, Never>
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
            //guard let chessMove = ChessMove(from: move.from.rawValue, to: move.to.int8Value ,on:game.board) else { return Effect.none }
            if(applyMoveIfValid(board:&game.board, move:move))
            {
                updateGameOver(game: &game)
                return enviroment
                            .didSuccefullyApplyMove()
                            .merge(with:requestNextTurn(game: game, enviroment: enviroment))
                            .eraseToEffect()
            }
       case .nextTurn:
           return requestNextTurn(game: game, enviroment: enviroment)
       case .offerDraw(_):
           // TODP: fix this
           // We are currently automatically acepting a draw.
           // If we are playiong online we should give the oponent an oppotunity ti accept or refuse.
           // If we are playing the computer, the chessengine should accpet or refuse depending on the value of the position.
           game.board.gamePlayState = .draw
           game.gameOver = GameOver(state: .draw(.agreement))
       case .resign(let player):
           let player = player ?? game.players.appUser!
           game.board.gamePlayState = .won(!player)
           game.gameOver = GameOver(state: .win(!player,.resignation))
       case .noValidMoves:
           game.board.gamePlayState = .draw
           game.gameOver = GameOver(state: .draw(.stalemate))
       case .timeout(let player):
           game.board.gamePlayState = .won(!player)
       case .setOnlineGame(let chessboard, let localPlayer):
           print("Setting the game to:")
           print(chessboard)
           game.board = chessboard
           switch localPlayer {
           case .white:
               game.players =   PlayerTypes(white: .appUser, black: .remote)
           case .black:
               game.players =  PlayerTypes(white:.remote, black: .appUser)
           }
          
           
           
       case .playComputerAs(let playerColor, let board ):
           game.board = board ?? Chessboard.start()
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
    case .setGame(let newGame):
        game = newGame
    case .saveCurrentGame:
        return enviroment.save(game: game)
    case .load:
        return enviroment.load()
    }
    return Effect.none
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

func updateGameOver(game:inout ChessGameState) {
    switch game.board.gamePlayState {
       case .won(let player):
            game.gameOver = GameOver(state: .win(player,.checkmate))
       case .draw:
            game.gameOver = GameOver(state: .draw(.stalemate))
       default:
            game.gameOver = nil
    }
}

