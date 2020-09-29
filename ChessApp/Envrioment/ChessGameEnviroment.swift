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
    
    func save(game:ChessGameState) -> Effect<ChessGameAction, Never>  {
        Effect<ChessGameAction, Never>.fireAndForget {
            if let encodeGame = try? JSONEncoder().encode(game) {
                UserDefaults.standard.setValue(encodeGame, forKey: "lastGame")
            }
        }
    }
    
    func load() -> Effect<ChessGameAction, Never>  {
        Effect<ChessGameAction, Never>.future
        {   callback in
            
            if let data = UserDefaults.standard.data(forKey: "lastGame"),
               let game = try? JSONDecoder().decode(ChessGameState.self,from:data)
            {
                  callback(.success(.setGame(game)))
            }
            
        }
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
