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

extension ChessEngine.PlayerColor {
    var checkerboardColor: CheckerboardView.PlayerColor {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}



struct RootView: View {
    
    let store = Store(initialState: AppState(), reducer: appReducer, environment: AppEnviroment())
    
    var body: some View {
        ChessboardView(store:self.store.scope(state: \.chessboardState, action: AppAction.selection))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
