//
//  GameCenterClient.swift
//  CAGameCenter
//
//  Created by David Crooks on 12/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit
import GameKit
import SwiftUI
import Combine


public class GameCenterClient<Game:TwoPlayerGame>:NSObject{
    public var rootVC:UIViewController!
    var matchVC:GKTurnBasedMatchmakerViewController?
    var authVC:UIViewController? //authcv?
    var matchmakerDelegate:TurnBasedMatchmakerDelegate<Game>?
    var currentMatch:GKTurnBasedMatch?
    var playerListener:PlayerListener<Game>?
    
    public func draw() -> Effect<GameCenterClientAction<Game>,Never> {
        guard let match = currentMatch else
       {
         //completion(GameCenterHelperError.matchNotFound)
           print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
           return Effect.none
       }
        
        return Effect.future
        {   callback in
            
            match.participants.forEach { other in
              other.matchOutcome = .tied
            }
            
            callback(.success(.gameOverWithWinner(nil)))
        }
    }
    
    public func lose() -> Effect<GameCenterClientAction<Game>,Never> {
        guard let match = currentMatch else
        {
            print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
            return Effect.none
        }
        
        return Effect.future
        {   callback in
            callback(.success(.gameOverWithWinner(.remote)))
        }
    }
    
    public func win() -> Effect<GameCenterClientAction<Game>,Never> {
        guard let match = currentMatch else
        {
            print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
            return Effect.none
        }
        
        return Effect.future
        {   callback in
            
            let localPlayerWon = true
            
            if(localPlayerWon){
                match.participants.forEach { other in
                  other.matchOutcome = .lost
                }
                match.currentParticipant?.matchOutcome = .won
            }
            else {
                match.participants.forEach { other in
                  other.matchOutcome = .won
                }
                match.currentParticipant?.matchOutcome = .lost
            }
            callback(.success(.gameOverWithWinner(.local)))
        }
    }
    
    
    public func sendTurnEvent(game:Game) -> Effect<GameCenterClientAction<Game>,Never> {
        guard let match = currentMatch else
        {
          
            print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
            return Effect.none
        }
        
        return Effect.fireAndForget {
            let next = match
                            .participants
                            .filter{ $0 != match.currentParticipant }
                
                assert(next.count == 1)
                let nextplayer = next.first!.player!
                
                
            
                do
                {
                    match.message = "your move, sucker!"
                    let encodeMatch = try JSONEncoder().encode(game)
                    // 2
                    match.endTurn(
                    withNextParticipants: next,
                    turnTimeout: GKExchangeTimeoutDefault,
                    match: encodeMatch,
                    completionHandler:  {   error in
                        //callback(.completedSendingTurn(error))
                                        }
                    )
                }
                catch
                {
                   // callback(.completedSendingTurn(error))
                }
        }
    }
    
    public func requestAuthorization() -> Effect<GameCenterClientAction<Game>,Never>
    {
        let effect = Effect<GameCenterClientAction<Game>, Never>.run
        {   subscriber  in

            self.playerListener = PlayerListener(subscriber: subscriber)
            GKLocalPlayer.local.register(self.playerListener!)
            GKLocalPlayer.local.authenticateHandler =
                { [weak self]   gcAuthVC, error in
                
                    
                    if let error = error
                    {
                        print("Error authentication to GameCenter!!!: " +
                                "\(error.localizedDescription)")
                       // TODO: handle errors
                        // subscriber.send(.authenticationError(error)
                      return
                    }
                    
                      if GKLocalPlayer.local.isAuthenticated
                      {
                       print("Local Player is Authenticated")
                       subscriber.send(.authenticated)

                      }
                      else if let vc = gcAuthVC
                      {
                        self?.rootVC.present(vc,animated: true)
                      }
                      else {
                          print("Local Player is not Authenticated and we do not have Auth VC")
                      }
                      
                      
            
                  }
            
            return AnyCancellable {}
        }

        return effect
    }
    
    public func getMatch() -> Effect<GameCenterClientAction<Game>,Never>
    {
        
        Effect.future
        { [weak self] callback in

            assert(Thread.isMainThread, "Not on the main thread!!!")
            print("So far so good")
            let request = GKMatchRequest()
            request.maxPlayers = 2
            request.minPlayers = 2
            request.inviteMessage = "Play my fun game"
            self?.matchmakerDelegate = TurnBasedMatchmakerDelegate(callback:callback,client: self!)
            
            let turnBasedMatchmakerVC = GKTurnBasedMatchmakerViewController(matchRequest: request)
            turnBasedMatchmakerVC.showExistingMatches = false
            
            turnBasedMatchmakerVC.turnBasedMatchmakerDelegate = self?.matchmakerDelegate
            self?.matchVC = turnBasedMatchmakerVC
            self?.rootVC.present( turnBasedMatchmakerVC, animated: true)
        }
        
    }

}

