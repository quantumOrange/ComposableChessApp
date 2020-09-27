//
//  ChessControlView.swift
//  ChessApp
//
//  Created by David Crooks on 26/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ChessControlView: View {
    let viewStore: ViewStore<AppState,AppAction>
    
    var body: some View {
        HStack {
            Spacer()
            IconButton( systemName: "line.horizontal.3", viewStore:viewStore, actions: [])
            Spacer()
            IconButton(systemName: "eye", viewStore:viewStore, actions: [])
            Spacer()
            IconButton( systemName: "lightbulb", viewStore:viewStore, actions: [])
            Spacer()
        }
        .foregroundColor(AppColorScheme.textColor)
    }
}



/****************************************************************************/
/************************      Preview   ****************************************/
/***************************************************************************/

fileprivate let mockViewStore =  ViewStore(Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))

struct ChessControlView_Previews: PreviewProvider {
    static var previews: some View {
        ChessControlView(viewStore:  mockViewStore)
    }
}
