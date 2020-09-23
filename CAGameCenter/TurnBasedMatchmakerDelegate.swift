//
//  Delegates.swift
//  Chess
//
//  Created by David Crooks on 06/01/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import GameKit

class TurnBasedMatchmakerDelegate<Game:TwoPlayerGame>:NSObject,GKTurnBasedMatchmakerViewControllerDelegate {
    
    init(callback:@escaping (Result<GameCenterClientAction<Game>,Never>)->(),client:GameCenterClient<Game>) {
        self.callback = callback
        self.client = client
    }
    var callback:(Result<GameCenterClientAction<Game>,Never>)->()
    
    weak var client:GameCenterClient<Game>!

    
  func turnBasedMatchmakerViewControllerWasCancelled(
    _ viewController: GKTurnBasedMatchmakerViewController) {

       print("Dissmiss GKTurnBasedMatchmakerViewController")
      viewController.dismiss(animated: true)
  }
  
  func turnBasedMatchmakerViewController(
    _ viewController: GKTurnBasedMatchmakerViewController,
    didFailWithError error: Error) {
      print("GKTurnBasedMatchmakerViewController did fail with error: \(error.localizedDescription).")
    //callback(.success(error))
  }
    
  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFind match: GKTurnBasedMatch){
    print("GKTurnBasedMatchmakerViewController did find match")
    viewController.dismiss(animated: true)
    client.currentMatch  = match
    callback(.success(.foundMatch))
    
  }

}


    


