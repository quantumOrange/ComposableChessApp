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
    var rootVC:UIViewController!
    var matchVC:GKTurnBasedMatchmakerViewController?
    var authVC:UIViewController? //authcv?
    var matchmakerDelegate:TurnBasedMatchmakerDelegate<Game>?
    var currentMatch:GKTurnBasedMatch?
    var playerListener:PlayerListener<Game>?
    
   // var matchmakerDelegateCallback:(Result<GameCenterClientAction<Game>,Error>)->() = { _ in fatalError()}
    
    
    func present(viewController:UIViewController){
        rootVC.present(viewController, animated: true)
    }
    
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
          //completion(GameCenterHelperError.matchNotFound)
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
          //completion(GameCenterHelperError.matchNotFound)
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
          //completion(GameCenterHelperError.matchNotFound)
            print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
            return Effect.none
        }
        
        return Effect.fireAndForget {
            let next = match
                            .participants
                            .filter{
                                //$0.player.i
                                $0 != match.currentParticipant
                                }
                
                print(next)
               // let status = next.first!.status
                
               // let nextparticpent = next.first!
                
                //nextparticpent.player
                let nextplayer = next.first!.player!
                print("match:Curret partcipemnt \(match.currentParticipant?.player?.displayName)")
                print("sending turn to :\(nextplayer.displayName)")
                
                assert(next.count == 1)
            
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
                        //callback(.endo(.completedSendingTurn(error)))
                                        }
                    )
                }
                catch
                {
                   // callback(.endo(.completedSendingTurn(error)))
                }
        }
    }
    
    public func requestAuthorization() -> Effect<GameCenterClientAction<Game>,Never>
    {
        let effect = Effect<GameCenterClientAction<Game>, Never>.run
        {   subscriber  in
           // self.subscriber = subscriber
            self.playerListener = PlayerListener(subscriber: subscriber)
            GKLocalPlayer.local.register(self.playerListener!)
            GKLocalPlayer.local.authenticateHandler =
                  {   gcAuthVC, error in
                      print("Run game center authenticateHandler callback")
                      if GKLocalPlayer.local.isAuthenticated
                      {
                          print("Local Player is Authenticated")
                        //callback(.success(.authenticated))
                      }
                      else if let vc = gcAuthVC
                      {
                          print("Local Player is not Authenticated - but we have Auth VC")
                          //callback(.endo(.presentAuthVC(vc)))
                        self.present(viewController: vc)
                      }
                      else {
                          print("Local Player is not Authenticated and we do not have Auth VC")
                      }
                      
                      if let error = error
                      {
                          print("Error authentication to GameCenter: " +
                                  "\(error.localizedDescription)")
                        //callback(.error(error))
                      }
            
                  }
            
            return AnyCancellable {}
        }
        /*
       GKLocalPlayer.local.authenticateHandler =
       {   gcAuthVC, error in
           print("Run game center authenticateHandler callback")
           if GKLocalPlayer.local.isAuthenticated
           {
               print("Local Player is Authenticated")
               callback(.endo(.authenticated))
           }
           else if let vc = gcAuthVC
           {
               print("Local Player is not Authenticated - but we have Auth VC")
               callback(.endo(.presentAuthVC(vc)))
           }
           else {
               print("Local Player is not Authenticated and we do not have Auth VC")
           }
           
           if let error = error
           {
               print("Error authentication to GameCenter: " +
                       "\(error.localizedDescription)")
           }
 
       }
        */
        return effect
    }
    
    public func getMatch() -> Effect<GameCenterClientAction<Game>,Never>
    {
        
        Effect.future
        { callback in
        ///       subscriber.send(MPMediaLibrary.authorizationStatus())
        ///
        ///       guard MPMediaLibrary.authorizationStatus() == .notDetermined else {
        ///         subscriber.send(completion: .finished)
        ///         return AnyCancellable {}
        ///       }
        ///
        ///       MPMediaLibrary.requestAuthorization { status in
        ///         subscriber.send(status)
        ///         subscriber.send(completion: .finished)
        ///       }
        ///       return AnyCancellable {
        ///         // Typically clean up resources that were created here, but this effect doesn't
        ///         // have any.
        ///       }
        ///     }
            let request = GKMatchRequest()
            request.maxPlayers = 2
            request.minPlayers = 2
            request.inviteMessage = "Play my fun game"
            self.matchmakerDelegate = TurnBasedMatchmakerDelegate(callback:callback,client: self)
            self.matchVC =  GKTurnBasedMatchmakerViewController(matchRequest: request)
            self.matchVC?.turnBasedMatchmakerDelegate = self.matchmakerDelegate
            
        }
        
    }

}

