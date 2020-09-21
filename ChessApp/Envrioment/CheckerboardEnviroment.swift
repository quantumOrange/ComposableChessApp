//
//  CheckerboardEnviroment.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CheckerboardView

class CheckerboardEnviroment:CheckerboardEnviromentProtocol {
    
    let applicationEnviroment:ApplicationEnviroment
       
    init(applicationEnviroment:ApplicationEnviroment)
    {
       self.applicationEnviroment = applicationEnviroment
    }
    
    func subscribe() -> Effect<CheckerboardAction, Never> {
        return applicationEnviroment.subscribe(localAction:/AppAction.checkerboard)
    }
    
    func playMove(move: Move) -> Effect<CheckerboardAction, Never> {
        applicationEnviroment.applyMove(move: move)
    }
    
}

