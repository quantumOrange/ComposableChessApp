//
//  DevButtons.swift
//  ChessApp
//
//  Created by David Crooks on 24/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct IdAction:Identifiable {
    let action:AppAction
    let name:String
    let id = UUID()
}

struct DevView: View {
    let store: Store<AppState,AppAction>
    
    let idactions:[IdAction] = [
                IdAction(action:   .gameCenter(.authenticate )    ,     name:".gameCenter(.authenticate )") ,
                IdAction(action:   .gameCenter(.findMatch )       ,     name:".gameCenter(.findMatch )"),
                IdAction(action:   .nav(.setShowChessgame(true) ) ,     name:".nav(.setShowChessgame(true) )")
    ]
    
    var body: some View {
        WithViewStore(self.store)
        {   viewStore in
            NavigationView
            {
                VStack
                {
                    ForEach(idactions) { idaction in
                        ActionButton(title: idaction.name, viewStore: viewStore, actions: [idaction.action])
                    }
                    
                    NavigationLink(destination: ChessGameView(store: self.store), isActive: viewStore.binding( get:{ $0.nav.showChessgame}  ,send: { AppAction.nav(.setShowChessgame($0)) } ) ){
                        EmptyView()
                    }.hidden()
                }
            }
        }
        
    }
}

struct DevView_Previews: PreviewProvider {
    static var previews: some View {
        DevView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}
