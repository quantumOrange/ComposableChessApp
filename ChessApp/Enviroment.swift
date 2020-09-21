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
import CAGameCenter

struct Enviroment {
    
    let applicationEnvirment = ApplicationEnviroment()
    
    let chessboardEnviroment:CheckerboardEnviroment
    let gameCenterClient = GameCenterClient<Chessboard>()
    let chessGameEnviroment:ChessGameEnviroment
    
    
    init() {
        self.chessboardEnviroment = CheckerboardEnviroment(applicationEnviroment:applicationEnvirment)
        self.chessGameEnviroment  = ChessGameEnviroment(applicationEnviroment:applicationEnvirment)
    }
    
}




extension Chessboard:TwoPlayerGame {
    public func currentPlayerTurn() -> Player {
        return .local //???
    }
}


