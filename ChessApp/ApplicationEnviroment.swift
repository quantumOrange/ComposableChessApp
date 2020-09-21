//
//  ApplicationEnviroment.swift
//  ChessApp
//
//  Created by David Crooks on 19/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import CAGameCenter
import ChessEngine
import CheckerboardView

final class ApplicationEnviroment {
    
    var subscribers:[Effect<AppAction,Never>.Subscriber] = []
    
    func send(action:AppAction){
        subscribers.forEach {
            $0.send(action)
        }
    }
    
    public func subscribeToAppActions() -> Effect<AppAction,Never>
    {
        return Effect<AppAction,Never>.run
        {   subscriber  in
            self.subscribers.append(subscriber)
            return AnyCancellable {}
        }
    }
    
    public func subscribe<LocalAction>(localAction:CasePath<AppAction, LocalAction>) -> Effect<LocalAction,Never> {
        subscribeToAppActions()
                 .compactMap { localAction.extract(from: $0) }
                 .eraseToEffect()
     }
    
    func didSuccefullyApplyMove() -> Effect<ChessGameAction, Never> {
        return Effect.fireAndForget
        {
            self.send(action: .checkerboard(.clear))
        }
    }
    
    func applyMove(move:CheckerboardView.Move) -> Effect<CheckerboardAction,Never>
    {
        return Effect.fireAndForget
        {
            let chessEngineMove = ChessEngine.Move(from:move.from.int8Value,to:move.to.int8Value)!
            let moveAction = AppAction.chessGame(.move(chessEngineMove))
            self.send(action: moveAction)
        }
    }
    
}
