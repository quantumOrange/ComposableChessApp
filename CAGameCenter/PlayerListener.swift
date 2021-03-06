//
//  PlayerListener.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import GameKit
import ComposableArchitecture

class PlayerListener<Game:TwoPlayerGame>:NSObject,GKLocalPlayerListener {
    
    init(subscriber:Effect<GameCenterClientAction<Game>, Never>.Subscriber){
        self.subscriber = subscriber
    }
    //static var shared:PlayerListener!
    var subscriber:Effect<GameCenterClientAction<Game>, Never>.Subscriber
    
     /**********GKTurnBasedEventListener******/
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch)
    {
         print(": Player \(player)   wantsToQuitMatch \(match)")
        
        let activeOthers = match.participants.filter { other in
                 other.status == .active
              }
              print(player.displayName)
              // 2
              // player.
              match.currentParticipant?.matchOutcome = .lost
                
              activeOthers.forEach { participant in
                participant.matchOutcome = .won
              }
              
              // 3
              match.endMatchInTurn(
                withMatch: match.matchData ?? Data()
              )
        
        
        subscriber.send(.gameOverWithWinner(.local))
    }

    func player(_ player: GKPlayer,receivedTurnEventFor match: GKTurnBasedMatch,didBecomeActive: Bool)
    {
       print(": Player \(player)   receivedTurnEventFor \(match)")
        
        let remotePlayer = match
                            .participants
                            .compactMap{$0.player}
                            .filter{
                                $0 != player
                                    }
                            .first
                            
        
        let isLocalPlayersTurn = match.currentParticipant?.player == player
        
        
        match.loadMatchData
        {   data, error in
           
            //TODO FIX ALL THIS! -> effect
            if let data = data
            {
               do
               {
                   let model = try JSONDecoder().decode(Game.self, from: data)
                
                   self.subscriber.send(.playerRceivedTurnEvent(model))
                   return
               }
               catch(let err)
               {
                    
                   print("Recieved turn event err 1: \n \(err)")
                 
               }
            }
            else
            {
                print("Error:No Data")
             
            }
            
            if let error = error {
                print("Recieved turn event err 2: \n \(error)")
            }
            
            self.subscriber.send(.playerRceivedTurnEvent(Game.start()))
        }

    }
    /************************** vvv don't care vvv**********************/
    func player(_ player:GKPlayer, didRequestMatchWithOtherPlayers players: [GKPlayer])
    {
       // Initiates a match from Game Center with the requested players.
        print(": Player \(player)  request match with  \(players)")
    }
    
    func player(_ player:GKPlayer, matchEnded: GKTurnBasedMatch)
    {
        //Called when the match has ended.
        print("Recieved exchange cancelation")
    }

    func player(_ player:GKPlayer, receivedExchangeCancellation turnBasedExchange: GKTurnBasedExchange, for TurnBasedMatch: GKTurnBasedMatch)
    {
        //Called when the exchange is cancelled by the sender.

        print("Recieved exchange cancelation")
    }
    
    func player(_ player: GKPlayer, receivedExchangeReplies: [GKTurnBasedExchangeReply], forCompletedExchange exchange: GKTurnBasedExchange, for match: GKTurnBasedMatch)
    {
        //Called when the exchange is completed.
        print("Exchange Event \(exchange)  match \(match)")
    }
    
    func player(_ player:GKPlayer, receivedExchangeRequest exchange: GKTurnBasedExchange, for match: GKTurnBasedMatch)
    {
        print("Exchange Event \(exchange)  match \(match)")
    }
    
    
    func player(_ player:GKPlayer, didAccept invite: GKInvite){
        print("\(player) accpeted invite \(invite)")
    }
    
   // Called when another player accepts a match invite from the local player.
    func player(_ player:GKPlayer, didRequestMatchWithRecipients recipients: [GKPlayer]){
        print("\(player) requested with \(recipients)")
    }

}
