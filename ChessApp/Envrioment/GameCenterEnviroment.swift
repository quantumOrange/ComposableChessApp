//
//  GameCenterEnviroment.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import CAGameCenter
import ComposableArchitecture

extension Chessboard:TwoPlayerGame {
    public func currentPlayerTurn() -> Player {
        return .local //???
    }
}

class GameCenterEnviroment:GameCenterEnviromentProtocol {
    func readyToPlay() -> Effect<GameCenterClientAction<Chessboard>, Never> {
        return applicationEnviroment.showGame()
    }
    
   
    let applicationEnviroment:ApplicationEnviroment
       
    init(applicationEnviroment:ApplicationEnviroment)
    {
       self.applicationEnviroment = applicationEnviroment
    }
    
    let client = GameCenterClient<Chessboard>()

    func subscribe() ->  Effect<GameCenterClientAction<Chessboard>,Never> {
        return applicationEnviroment.subscribe(localAction:/AppAction.gameCenter)
    }
    
}


