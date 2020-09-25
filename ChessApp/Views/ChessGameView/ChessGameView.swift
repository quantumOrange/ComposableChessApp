//
//  ChessGameView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ChessGameView : View {
    let store: Store<AppState,AppAction>
    
    var body: some View
    {
        VStack(alignment:.center )
        {
           // Spacer()
                
            PlayerView(store: self.store.scope(state: \.topPlayer ).actionless)
               
                //.padding()
            
            ChessboardView(store:self.store.scope(state: \.chessboardState, action: AppAction.checkerboard)).debugOutline()
                //.padding()
                
            PlayerView(store: self.store.scope(state: \.bottomPlayer ).actionless)
                //.padding()
            
           Spacer()
                
        }
        
    }
}


#if DEBUG


struct ChessGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChessGameView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}


#endif
