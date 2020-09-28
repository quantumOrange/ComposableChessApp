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
        WithViewStore(self.store)
        {   viewStore in
            VStack(alignment:.center,spacing:0 )
            {
                
                ZStack {
                    Rectangle()
                        .fill(AppColorScheme.insetInsetBackgroundColor)
                        .edgesIgnoringSafeArea(.all)
                    HStack {
                        IconButton(systemName:"chevron.left",viewStore: viewStore, actions: [.nav(.setShowChessgame(false))])
                            .foregroundColor(AppColorScheme.textColor)
                        Spacer()
                    }
                    .padding([.leading,.trailing,.bottom])
                }
                
                PlayerView(store: self.store.scope(state: \.topPlayer ).actionless)
                  
                ChessboardView(store:self.store.scope(state: \.chessboardState, action: AppAction.checkerboard))
                    .layoutPriority(100)
                     
                PlayerView(store: self.store.scope(state: \.bottomPlayer ).actionless)
                   
                ZStack {
                    Rectangle()
                        .fill(AppColorScheme.insetInsetBackgroundColor)
                        .edgesIgnoringSafeArea(.all)

                    ChessControlView(viewStore: viewStore)
                        
                }
                
                NavigationLink(destination: ExploreView(), isActive: viewStore.binding( get:{ $0.nav.showExplore}  ,send: { AppAction.nav(.setShowExplore($0)) } ) ){
                    EmptyView()
                }.hidden()
            }
            .navigationBarHidden(true)
            
        }
        .debugOutline()
        
    }
}


#if DEBUG

struct ChessGameView_Previews: PreviewProvider {
    static var previews: some View {
        ChessGameView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}


#endif
