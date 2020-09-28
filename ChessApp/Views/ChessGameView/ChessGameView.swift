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
                        IconButton(systemName:"chevron.left", store:self.store.stateless, actions: [.nav(.setShowChessgame(false))])
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

                    ChessControlView( store:self.store.stateless)
                        
                }
                
                NavigationLink(destination: ExploreView(), isActive: viewStore.binding( get:{ $0.nav.showExplore}  ,send: { AppAction.nav(.setShowExplore($0)) } ) ){
                    EmptyView()
                }.hidden()
            }
            .navigationBarHidden(true)
            .alert(item:.constant(viewStore.state.chessGame.gameOver))
            {   alert in
                Alert(title: Text("Game Over"), message: Text(alert.text), dismissButton: .default(Text("OK")))
            }
            .actionSheet(isPresented: viewStore.binding( get:{ $0.nav.showGameOptionsActionSheet}  ,send: { AppAction.nav(.setShowGameOptionsActionSheet($0)) } ), content: {
                ActionSheet(
                                title: Text("Chess Game"),
                                message: Text("Available options"),
                                buttons: [
                                    .destructive(Text("Resign")){ viewStore.send(.chessGame(.resign(.white))) },
                                    .default(Text("Offer Draw")){ viewStore.send(.chessGame(.offerDraw(.white))) },
                                    .cancel()
                                ]
                            )
            })
            
            
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
