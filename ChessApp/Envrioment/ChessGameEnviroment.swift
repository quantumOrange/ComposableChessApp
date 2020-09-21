//
//  ChessGameEnviroment.swift
//  ChessApp
//
//  Created by David Crooks on 21/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import ComposableArchitecture

class ChessGameEnviroment:ChessGameEnviromentProtocol
{
    func didSuccefullyApplyMove() -> Effect<ChessGameAction, Never> {
        return applicationEnviroment.didSuccefullyApplyMove()
    }
    
    let applicationEnviroment:ApplicationEnviroment
    
    init(applicationEnviroment:ApplicationEnviroment)
    {
        self.applicationEnviroment = applicationEnviroment
    }
    
    func sendTurnToGameCenter(board: Chessboard) -> Effect<ChessGameAction, Never>
    {
        applicationEnviroment.sendTurnToGameCenter(chessboard:board)
    }
       
    func chessEnginePickMove(board: Chessboard) -> Effect<ChessGameAction, Never>
    {
        let effect = Effect<ChessGameAction, Never>.future
               {   callback in
                   DispatchQueue.global(qos: .background).async
                   {
                        if let move = pickMove(for: board)
                        {
                            DispatchQueue.main.async
                            {
                                callback(.success(.chessMove(move)))
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async
                            {
                                callback(.success(.noValidMoves))
                            }
                        }
                   }
               }
               
        return effect
    }
    
    func subscribeToApplication() ->  Effect<ChessGameAction, Never>{
        return applicationEnviroment.subscribe(localAction:/AppAction.chessGame)
    }
}
