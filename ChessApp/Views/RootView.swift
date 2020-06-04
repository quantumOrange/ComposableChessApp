//
//  ContentView.swift
//  ChessApp
//
//  Created by David Crooks on 03/06/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {

    var body: some View {
       
        ChessboardView(store:mockStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
