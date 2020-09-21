//
//  AppState+PlayerViewModel.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
extension AppState {
   var whitePlayer:PlayerViewModel {
        return PlayerViewModel(
                                name: "Mr White",
                                player: .white,
                                type: chessGame.players.player(for: .white),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .white)
                            )
    }
    
    var blackPlayer:PlayerViewModel {
        return PlayerViewModel(
                                name: "Mr Black",
                                player: .black,
                                type: chessGame.players.player(for: .black),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .black)
                                )
    }
    
    var topPlayer:PlayerViewModel {
        switch playerPointOfView {
        case .white:
            return blackPlayer
        case .black:
            return whitePlayer
        }
    }
    
    var bottomPlayer:PlayerViewModel {
        switch playerPointOfView {
        case .white:
            return whitePlayer
        case .black:
            return blackPlayer
        }
    }
}
