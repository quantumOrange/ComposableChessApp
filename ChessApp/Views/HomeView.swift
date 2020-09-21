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
    
    var body: some View
    {
        WithViewStore(self.store)
        { viewStore in
            NavigationView
            {
                VStack(alignment: .center, spacing: 50)
                {
                    Button(action: {
                        viewStore.send(.chessGame(.playComputerAs(.white, nil)) )
                        viewStore.send(.nav(.setShowChessgame(true) ))
                    })
                    {
                        Text("Play Computer")
                    }
                    
                    Button(action: { viewStore.send(.gameCenter(.userRequestsGame )) })
                    {
                        Text("Play Online")
                    }
                    
                    NavigationLink(destination: ChessGameView(store: self.store), isActive: viewStore.binding( get:{ $0.nav.showChessgame}  ,send: { AppAction.nav(.setShowChessgame($0)) } ) ){
                        EmptyView()
                    }.hidden()
                    
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}

