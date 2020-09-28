//
//  Navigation.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture

enum NavAction {
    case setShowChessgame(Bool)
    case setShowExplore(Bool)
    case setShowSettings(Bool)
    case setShowGameOptionsActionSheet(Bool)
    case gotTo(NavState.Destinations)
}

struct NavState:Equatable {
    
    enum Destinations:Equatable {
        enum ChessGame {
            case root
            case explore
        }
        
        case home
        case chessgameview(ChessGame)
        case settings
        //case explore
    }
    var showGameOptionsActionSheet:Bool = false
    var destination = Destinations.home
    
    var showChessgame:Bool
    {
        switch destination
        {
        case .chessgameview(_):
            return true
        default:
            return false
        }
    }
    
    var showExplore:Bool {
        switch destination
        {
        case .chessgameview(let chessView):
            return chessView == .explore
        default:
            return false
        }
    }
    
    var showSettings:Bool { destination == .settings }
}

let navReducer = Reducer<NavState, NavAction, ()> { state,action, env in
    switch action
    {
        
    case .setShowChessgame(let show):
        if show {
            state.destination = .chessgameview(.root)
        }
        else if state.showChessgame {
            state.destination = .home
        }
    case .gotTo(let destination):
        state.destination = destination
    case .setShowExplore(let show):
        if show {
            state.destination = .chessgameview(.explore)
        }
        else if state.showExplore {
            state.destination = .chessgameview(.root)
        }
        else {
            // ignore
        }
    case .setShowSettings(let show):
        if show {
            state.destination = .settings
        }
        else if state.showSettings {
            state.destination = .home
        }
    case .setShowGameOptionsActionSheet(let value):
        state.showGameOptionsActionSheet = value
    }
    return Effect.none
}



