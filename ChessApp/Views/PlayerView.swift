//
//  PlayerView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import ChessEngine
import ComposableArchitecture

struct PlayerViewModel:Equatable {
    var name:String
    var player:PlayerColor
    var type:PlayerType
    var isPlayersTurn:Bool
}

func iconImageName(_ player:PlayerColor) -> String {
    switch player {
    case .white:
        return "person"
    case .black:
        return "person.fill"
    }
}

func statusImageName(_ player:PlayerType) -> String {
    switch player {
        
    case .none:
        return "person.crop.circle.fill.badge.xmark"
    case .appUser:
        return "person.crop.circle.fill"
    case .remote:
        return "antenna.radiowaves.left.and.right"
    case .computer:
        return "desktopcomputer"
    }
    
}

struct PlayerView : View {
    let store: Store<PlayerViewModel,Never>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(alignment: .center) {
                
                Image(systemName: iconImageName(viewStore.state.player))
                   .font(.title)
                Text(viewStore.state.name)
                Image(systemName: statusImageName(viewStore.state.type))
                if(viewStore.state.isPlayersTurn) {
                    Image(systemName:"hand.point.left")
                }
            }
        }
    }
}

#if DEBUG
let mockPVState = PlayerViewModel(name: "Mr White", player: .white, type: .computer, isPlayersTurn: true)

let mockPVReducer = Reducer<PlayerViewModel,Never,Void>{ _ , _, _ in  .none }

let mockPVStore = Store(initialState: mockPVState, reducer: mockPVReducer, environment: ())
struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
 
        
        
        PlayerView(store: mockPVStore)
    }
}

#endif
