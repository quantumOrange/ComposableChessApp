//
//  GameOverState.swift
//  ChessApp
//
//  Created by David Crooks on 28/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation


import SwiftUI
import ChessEngine

struct GameOver:Equatable {
    let state:State
    
    enum State:Equatable {
        case win(PlayerColor,WinReason)
        case draw(DrawReason)
    }
    
    enum WinReason:String,Equatable {
        case checkmate
        case timeout
        case resignation
    }
    
    enum DrawReason:String,Equatable {
        case timeoutVsInsuffiecentMaterial
        case stalemate
        case agreement
        case repetion
    }
}

extension GameOver:Identifiable {
    var id:String { text }
    
    var text:String {
        switch self.state {
            
        case .win(let player,let reason):
            return "\(player) wins by \(reason)"
        case .draw(let reason):
            return "The game was a draw (\(reason))"
       
        }
    }
}


