//
//  GameCenterState.swift
//  CAGameCenter
//
//  Created by David Crooks on 12/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture

public enum Player {
    case local // = white
    case remote // = black
}

prefix func !(v:Player)-> Player {
    switch v {
    case .local:
        return .remote
    case .remote:
        return .local
    }
}


public protocol TwoPlayerGame:Codable {
    static func start() -> Self
    func currentPlayerTurn() -> Player
}

public struct GameCenterState<Game:TwoPlayerGame>
{
    var isAuthenticated = false
    var isMatched = false
    
    var isSendingTurn = false
    
    var firstMover:Player?  // == white
    
    var localPlayerDisplayName:String?
    
    var remotePlayerDisplayName:String?
    
    var game:Game
    
}

public enum GameCenterClientAction<Game:TwoPlayerGame> {
    case authenticate
    case authenticated
    case findMatch
    case foundMatch
    
    case sendTurn(Game)
    case playerRceivedTurnEvent(Game)
    case gameOverWithWinner(Player?)
}



public func gameReducer<Game:TwoPlayerGame>( state:inout GameCenterState<Game>, action:GameCenterClientAction<Game>, environment:GameCenterClient<Game>) -> Effect<GameCenterClientAction<Game>,Never> {
    

    switch action {
    case .authenticate:
        return environment.requestAuthorization()
    case .findMatch:
        return environment.getMatch()
    case .authenticated:
        state.isAuthenticated = true
    case .foundMatch:
        state.isMatched = true
        
    case .sendTurn(let game):
        return environment.sendTurnEvent(game: game)
    case .playerRceivedTurnEvent(let game):
        state.game = game
    case .gameOverWithWinner(_):
        state.isSendingTurn = false
        state.isMatched = false
    
    }
    
    return Effect.none
}
