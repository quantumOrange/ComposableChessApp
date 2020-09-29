//
//  AppState+PlayerViewModel.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import UIKit
extension AppState {
    
   var whitePlayer:PlayerViewModel {
        let details = playerDetails(for: .white)
        return PlayerViewModel(
                                details:details,
                                player: .white,
                                type: chessGame.players.player(for: .white),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .white),
                                takenPieces: chessGame.board.takenPieces
                            )
    }
    
    var blackPlayer:PlayerViewModel {
        let details = playerDetails(for: .black)
        return PlayerViewModel(
                                details:details,
                                player: .black,
                                type: chessGame.players.player(for: .black),
                                isPlayersTurn: (chessGame.board.whosTurnIsItAnyway == .black),
                                takenPieces: chessGame.board.takenPieces
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
    
    func playerDetails(for color:PlayerColor ) -> PlayerDetails
    {
        switch chessGame.players.player(for:color)
        {
        
        case .none:
            return PlayerDetails(displayName:"", image: nil)
        case .appUser:
            return user
        case .remote:
            return remote
        case .computer:
            return computer
        }
    }
}
