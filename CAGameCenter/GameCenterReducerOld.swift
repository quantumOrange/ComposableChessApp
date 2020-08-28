//
//  GameCenterReducer.swift
//  Chess
//
//  Created by David Crooks on 17/11/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
import GameKit
import SwiftUI
import UIKit
import Combine
import Contacts

/*
enum GameCenterAction
{
    //case sendMove(ChessMove)
    //case recieveMove(ChessMove)
    case activate
    case authenticated
   
    case getMatch
    
    case foundMatch(GKTurnBasedMatch)

    //case match(MatchAction)
    
    case presentMatchmakerViewController(GKTurnBasedMatchmakerViewControllerDelegate)
    case presentAuthVC(UIViewController)
    
    case setPlayerListener(GKLocalPlayerListener)
    case playerListener(PlayerListernerAction)
    
    case localPlayerFinishedTurn( Chessboard )
    case remotePlayerFinishedTurn
    
    case completedSendingTurn(Error?)
}


enum GameCenterExoAction {
    case receivedTurn(Chessboard,PlayerColor)
    // case beginGame
    // case foundMatch( GKTurnBasedMatch)
}

struct OldGameCenterState
{
    var isAuthenticated = false
    var authVC:IndentifiableVC?
    
    //var matchVC:GKTurnBasedMatchmakerViewController?
  
    var currentMatch:GKTurnBasedMatch?
    var isSendingTurn = false
    
    var localPlayerColor:PlayerColor?
    
    var remotePlayerColor:PlayerColor? {
        guard let localPlayerColor = localPlayerColor else { return nil }
        return !localPlayerColor
    }
    
    var localPlayerDisplayName:String?
    
    var remotePlayerDisplayName:String?
    
}

struct IndentifiableVC:Identifiable
{
    var id: Int
    var viewController:UIViewController
}

struct AnyViewController:UIViewControllerRepresentable
{
    
    var viewController:UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        return self.viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AnyViewController>)
    {
           
    }
}

func gameCenterReducer(_ state:inout OldGameCenterState,_ action:GameCenterAction) -> Effect<Output<GameCenterAction,GameCenterExoAction>>
{
    switch action
    {
    case .localPlayerFinishedTurn( let chessboard ):
        if (state.isSendingTurn) {
            print("Trying to send turn, But e are sending a turn already. Dont send another one!")
            break
        }
        state.isSendingTurn = true
        guard let match = state.currentMatch else
        {
          //completion(GameCenterHelperError.matchNotFound)
            print("Ooops - we are not sending the turn becuase we don't yet have a match. This is probaly not good.")
            return Effect.empty()
        }
        print(" We are about to return (and run) an effect to send the turn.")
        print("This should be the local player: \(match.currentParticipant?.player?.displayName)")
        
        if let localName = state.localPlayerDisplayName ,
            let displayName =  match.currentParticipant?.player?.displayName
            {
            assert(localName == displayName , "Local player changed from \(localName) to \(displayName) match: \(match) ")
        }
        
        
        
        switch chessboard.gamePlayState {
            
        case .won(let winningPlayer):
            //we have just finishe our turn , so we are the other color
            let localPlayerColor = !(chessboard.whosTurnIsItAnyway)
            return winEffect(           match: match,
                               localPlayerWon: (localPlayerColor == winningPlayer),
                                   chessboard: chessboard)
        case .draw:
            return drawEffect(match: match,chessboard:chessboard)
        case .inPlay:
            return sendTurnEffect(match: match,chessboard:chessboard)
        
        }
        
    case .completedSendingTurn(let error):

        state.isSendingTurn = false
        return Effect.log(error: error)
    case .remotePlayerFinishedTurn:
        break
    case .activate:
        return Effect.async
        {   callback in
            print("---")
            print("Run game center effect")
            
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
        }
        
       // return effect
       
    case .authenticated:
        state.isAuthenticated = true
        return Effect.async
        {   callback in
            
            callback(.endo(.setPlayerListener(PlayerListener.shared!)))
        }
       // return effect
        
    case .setPlayerListener(let playerListener):
        //state.playerListener = playerListener
        return Effect.fireAndForget
        {
            print("Register player listener")
            GKLocalPlayer.local.register(playerListener)
        }
        
    case .presentAuthVC(let authVC):
        state.authVC = IndentifiableVC(id:0, viewController: authVC)
        
     case .getMatch:

        return Effect.async
        {   callback in
            let delegate = TurnBasedMatchmakerDelegate.shared!
            callback(.endo(.presentMatchmakerViewController(delegate)))
        }
        
        //return matchMakerDelegateEffect
        
    case .presentMatchmakerViewController(let delegate):
        let request = GKMatchRequest()
        request.maxPlayers = 2
        request.minPlayers = 2
        request.inviteMessage = "Play my fun game"
        
        let matchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        matchmakerViewController.turnBasedMatchmakerDelegate = delegate
        //state.matchVC  = matchmakerViewController
        
        return Effect.present(matchmakerViewController)
        
    case .playerListener(let action):
        return playerListenerReducer(state: &state, action: action)
    
    case .foundMatch(let match):
        print( "Current participent" )
        if let current = match.currentParticipant {
            print( current)
        }
       
        print( "---" )
        print( match.participants)
    }
    return Effect.empty()
}



func winEffect(match:GKTurnBasedMatch, localPlayerWon:Bool, chessboard:Chessboard) -> Effect<Output<GameCenterAction,GameCenterExoAction>> {
    
    return Effect<Output<GameCenterAction,GameCenterExoAction>>.async
    {   callback in
        
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
        print("outcome:")
        match.participants.forEach {print( $0.matchOutcome)}
        print("--")
        
        match.message = "Game over"
        do
        {
            let encodeMatch = try JSONEncoder().encode(chessboard)
            match.endMatchInTurn(
              withMatch: encodeMatch,
              completionHandler: {   error in
                                        callback(.endo(.completedSendingTurn(error)))
                                  }
            )
        }
            catch {
                callback(.endo(.completedSendingTurn(error)))
            }
    }
}

func drawEffect(match:GKTurnBasedMatch, chessboard:Chessboard) -> Effect<Output<GameCenterAction,GameCenterExoAction>> {
    
    return Effect<Output<GameCenterAction,GameCenterExoAction>>.async
    {   callback in
        
        
        match.participants.forEach { other in
          other.matchOutcome = .tied
        }
        //match.currentParticipant?.matchOutcome = .tied
       
        print("outcome: \(String(describing: match.currentParticipant?.matchOutcome))")
        
        
        match.message = "Game drawn"
        
        do
        {
            let encodeMatch = try JSONEncoder().encode(chessboard)
            match.endMatchInTurn(
              withMatch: encodeMatch,
              completionHandler: {   error in
                                        callback(.endo(.completedSendingTurn(error)))
                                  }
            )
        }
            catch {
                callback(.endo(.completedSendingTurn(error)))
            }
    }
}


func sendTurnEffect(match:GKTurnBasedMatch, chessboard:Chessboard) -> Effect<Output<GameCenterAction,GameCenterExoAction>> {
    return Effect<Output<GameCenterAction,GameCenterExoAction>>.async
    {   callback in
        
        // match.currentParticipant
        
        let next = match
                    .participants
                    .filter{
                        //$0.player.i
                        $0 != match.currentParticipant
                        }
        
        print(next)
        let status = next.first!.status
        
        let nextparticpent = next.first!
        
        nextparticpent.player
        let nextplayer = next.first!.player!
        print("match:Curret partcipemnt \(match.currentParticipant?.player?.displayName)")
        print("sending turn to :\(nextplayer.displayName)")
        
        assert(next.count == 1)
    
        do
        {
            match.message = "message-To-Display"
            let encodeMatch = try JSONEncoder().encode(chessboard)
            // 2
            match.endTurn(
            withNextParticipants: next,
            turnTimeout: GKExchangeTimeoutDefault,
            match: encodeMatch,
            completionHandler:  {   error in
                callback(.endo(.completedSendingTurn(error)))
                                }
            )
        }
        catch
        {
            callback(.endo(.completedSendingTurn(error)))
        }
    }
}
*/
