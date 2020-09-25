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
                    
                    Spacer()
                    
                    ActionButton(title: "Play Computer", viewStore: viewStore, actions:
                                    [
                                        .chessGame(.playComputerAs(.white, nil)),
                                        .nav(.setShowChessgame(true) )
                                    ])
                        .padding()
                    
                    ActionButton(title: "Play Online", viewStore: viewStore, actions: [.gameCenter(.userRequestsGame ) ])
                        .padding()
                    
                    NavigationLink(destination: ChessGameView(store: self.store), isActive: viewStore.binding( get:{ $0.nav.showChessgame}  ,send: { AppAction.nav(.setShowChessgame($0)) } ) ){
                        EmptyView()
                    }.hidden()
                    
                    Spacer()
                }
                
            }
            .navigationBarTitle("Chess")
        }
        
    }
    
   
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}

