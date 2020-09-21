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
    case gotTo(NavState.Destinations)
}

struct NavState:Equatable {
    
    enum Destinations:Equatable {
        case home
        case chessgameview
    }
    
    var destination = Destinations.home
    
    var showChessgame:Bool { destination == .chessgameview }
}

let navReducer = Reducer<NavState, NavAction, ()> { state,action, env in
    switch action {
        
    case .setShowChessgame(let show):
        if show {
            state.destination = .chessgameview
        }
        else if state.showChessgame {
            state.destination = .home
        }
    case .gotTo(let destination):
        state.destination = destination
    }
    return Effect.none
}



