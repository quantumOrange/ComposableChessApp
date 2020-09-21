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

public struct GameCenterMatchState:Equatable {
    public var isAuthenticated = false
    public var isMatched = false
    public var isSendingTurn = false
    public var firstMover:Player?  // == white
    
    public init() {}
}


public struct GameCenterState<Game:TwoPlayerGame>
{
    public var matchState:GameCenterMatchState
    public var localPlayerDisplayName:String?
    public var remotePlayerDisplayName:String?
    public var game:Game
}

extension GameCenterState {
    public init( game:Game, matchState:GameCenterMatchState,   localPlayerDisplayName:String,remotePlayerDisplayName:String)
    {
        self.matchState = matchState
        self.localPlayerDisplayName = localPlayerDisplayName
        self.remotePlayerDisplayName = remotePlayerDisplayName
        self.game = game
    }
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
        state.matchState.isAuthenticated = true
    case .foundMatch:
        state.matchState.isMatched = true
        
    case .sendTurn(let game):
        return environment.sendTurnEvent(game: game)
    case .playerRceivedTurnEvent(let game):
        state.game = game
    case .gameOverWithWinner(_):
        state.matchState.isSendingTurn = false
        state.matchState.isMatched = false
    
    }
    
    return Effect.none
}
