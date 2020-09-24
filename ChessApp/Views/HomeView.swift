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
        WithViewStore(self.store)
        { viewStore in
            NavigationView
            {
                VStack(alignment: .center)
                {
                    
                    Image("ChessHomeIcon")
                    
                    Spacer(minLength: 50)
                    
                    ActionButton(title: "Play Computer", viewStore: viewStore, actions:
                                    [
                                        .chessGame(.playComputerAs(.white, nil)),
                                        .nav(.setShowChessgame(true) )
                                    ])
                    
                    ActionButton(title: "Play Online", viewStore: viewStore, actions: [.gameCenter(.userRequestsGame ) ])
                    
                    NavigationLink(destination: ChessGameView(store: self.store), isActive: viewStore.binding( get:{ $0.nav.showChessgame}  ,send: { AppAction.nav(.setShowChessgame($0)) } ) ){
                        EmptyView()
                    }.hidden()
                    
                }
                .padding()
            }
            .navigationBarTitle("Navigation")
        }
        
    }
    
    
    let buttonBackgroundColor = Color(red:172.0/255, green:172.0/255,blue: 232.0/255)
    let buttonTextColor = Color(red:0.0, green:0.0,blue: 200.0/255)
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}

