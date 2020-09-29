//
//  HomeView.swift
//  ChessApp
//
//  Created by David Crooks on 18/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//
import ComposableArchitecture
import SwiftUI

struct HomeView: View
{
    let store: Store<AppState,AppAction>
    let devMode = false
    var body: some View
    {

        NavigationView
        {
            WithViewStore(self.store)
            {   viewStore in
                
                VStack(alignment: .center)
                {
                    
                    Image("ChessHomeIcon")
                        .resizable()
                        .frame(width: 240, height: 240, alignment: .center)
                    
                    Spacer()
                    
                    ActionButton(title: "New game As White", viewStore: viewStore, actions:
                                    [
                                        .chessGame(.playComputerAs(.white, nil)),
                                        .checkerboard(.reset),
                                        .nav(.setShowChessgame(true) )
                                    ])
                        .padding()
                    
                    ActionButton(title: "New game As Black", viewStore: viewStore, actions:
                                    [
                                        .chessGame(.playComputerAs(.black, nil)),
                                        .checkerboard(.reset),
                                        .nav(.setShowChessgame(true) )
                                    ])
                        .padding()
                    
                    if viewStore.state.chessGame.inPlay {
                        ActionButton(title: "Continue Game", viewStore: viewStore, actions:
                                        [
                                            .checkerboard(.reset),
                                            .nav(.setShowChessgame(true) )
                                        ])
                            .padding()
                    }
                    
            
                    ActionButton(title: "Play Online", viewStore: viewStore, actions: [.gameCenter(.userRequestsGame ) ])
                        .padding()
                    
                    NavigationLink(destination: ChessGameView(store: self.store), isActive: viewStore.binding( get:{ $0.nav.showChessgame}  ,send: { AppAction.nav(.setShowChessgame($0)) } ) ){
                        EmptyView()
                    }.hidden()
                    
                    NavigationLink(destination: SettingsView(), isActive: viewStore.binding( get:{ $0.nav.showSettings}  ,send: { AppAction.nav(.setShowSettings($0)) } ) ){
                        EmptyView()
                    }.hidden()
                    
                    Spacer()
                }
                .navigationBarItems(trailing:
                                        IconButton( systemName: "gear", store:self.store.stateless, actions: [.nav(.setShowSettings(true) )]))
                .navigationBarTitle("Chess")
        
            }
            
        }
        
    }
    
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}

