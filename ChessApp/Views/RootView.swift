//
//  ContentView.swift
//  ChessApp
//
//  Created by David Crooks on 03/06/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import CheckerboardView
import ChessEngine


struct RootView: View {
    let store:Store<AppState,AppAction>
    
    init(store:Store<AppState,AppAction>) {
        self.store = store
    }
    
    var body: some View {
        HomeView(store:self.store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store:Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))
    }
}
