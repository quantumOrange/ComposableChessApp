//
//  AppState+PlayerViewModel.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import UIKit
extension AppState {
   var whitePlayer:PlayerViewModel {
        return PlayerViewModel(
                                name: "Mr White",
                                player: .white,
                                type: chessGame.players.player(for: .white),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .white),
                                image: UIImage(named:"defaultUser")!
                            )
    }
    
    var blackPlayer:PlayerViewModel {
        return PlayerViewModel(
                                name: "Mr Black",
                                player: .black,
                                type: chessGame.players.player(for: .black),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .black),
                                image: UIImage(named:"defaultComputer")!
                                )
    }
    
    var topPlayer:PlayerViewModel {
        switch boardstate.playerPointOfView {
        case .white:
            return blackPlayer
        case .black:
            return whitePlayer
        }
    }
    
    var bottomPlayer:PlayerViewModel {
        switch boardstate.playerPointOfView {
        case .white:
            return whitePlayer
        case .black:
            return blackPlayer
        }
    }
}
