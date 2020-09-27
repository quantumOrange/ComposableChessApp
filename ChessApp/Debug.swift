//
//  Debug.swift
//  CAGameCenter
//
//  Created by David Crooks on 23/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CAGameCenter
import ChessEngine

let debugGameCenterReducer = gameCenterReducer.debug( state:\.debugState, action: debugGameCenterCasePath)

let debugGameCenterCasePath = CasePath<GameCenterClientAction<Chessboard>,GameCenterClientAction<String>>(embed: { _ in fatalError()}, extract: extract )

extension GameCenterState  where Game:CustomStringConvertible {
    public var debugState: GameCenterDebugState {
        GameCenterDebugState(matchState: matchState, localPlayerDisplayName: localPlayerDisplayName, remotePlayerDisplayName: remotePlayerDisplayName, game:debugBoardString(game))
    }
}

public struct GameCenterDebugState {
    public var matchState:GameCenterMatchState
    public var localPlayerDisplayName:String?
    public var remotePlayerDisplayName:String?
    public var game:String 
}


func debugBoardString(_ value:CustomStringConvertible) -> String {
    let invalidCharacters = CharacterSet.whitespacesAndNewlines.union(CharacterSet.decimalDigits)
    return "\(value)".filter{
        !invalidCharacters.contains($0.unicodeScalars.first!)
    }
}

func extract(value: GameCenterClientAction<Chessboard>) -> GameCenterClientAction<String> {
    switch value {
    case .subscribe:
        return .subscribe
    case  .userRequestsGame:
        return .userRequestsGame
    case  .authenticate:
        return .authenticate
    case  .authenticated:
        return .authenticated
    case  .findMatch:
        return .findMatch
    case  .foundMatch:
        return .foundMatch
    case  .sendTurn(let board):
        return .sendTurn(debugBoardString(board))
    case  .playerRceivedTurnEvent(let board):
        return .playerRceivedTurnEvent(debugBoardString(board))
    case .gameOverWithWinner(let player):
        return .gameOverWithWinner(player)
    }
}


