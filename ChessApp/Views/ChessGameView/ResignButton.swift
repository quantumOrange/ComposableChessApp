//
//  ResignButton.swift
//  ChessApp
//
//  Created by David Crooks on 28/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture




struct ResignButton: View {
    
    init( viewStore:ViewStore<AppState,AppAction>)
    {
        self.viewStore = viewStore
    }
    
    let viewStore: ViewStore<AppState,AppAction>
    
    var body: some View {
        Button(action: {viewStore.send(AppAction.chessGame(.resign(.white)))} , label: {
            VStack {
                
                Text("♔")
                    .rotationEffect(Angle(degrees: 45))
                    .font(Font.largeTitle)
                
            }

        })
        
    }
    
    let buttonBackgroundColor = AppColorScheme.insetBackgroundColor
    let buttonTextColor = AppColorScheme.textColor
}

fileprivate let mockViewStore =  ViewStore(Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))

struct ResignButton_Previews: PreviewProvider {
    static var previews: some View
    {
        HStack
        {
            
            Spacer()
            IconButton(systemName: "line.horizontal.3", viewStore:mockViewStore, actions: [])
            Spacer()
            ResignButton(viewStore:mockViewStore)
            Spacer()
        }
    }
}
