//
//  IconButton.swift
//  ChessApp
//
//  Created by David Crooks on 26/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct IconButton: View {
    
    init(systemName: String, viewStore:ViewStore<AppState,AppAction>, actions: [AppAction],title:String? = nil){
        self.title = title
        self.actions = actions
        self.viewStore = viewStore
        self.systemName = systemName
    }
    
    let title:String?
    let systemName:String
    let viewStore: ViewStore<AppState,AppAction>
    let actions:[AppAction]
    
    var body: some View {
        Button(action:{ actions.forEach{viewStore.send($0)} }, label: {
            VStack {
                
                Image(systemName:systemName)
                    .font(Font.title)
                
                if let title = title {
                    Text(title)
                }
                
            }

        })
        
    }
    
    let buttonBackgroundColor = AppColorScheme.insetBackgroundColor
    let buttonTextColor = AppColorScheme.textColor
}

fileprivate let mockViewStore =  ViewStore(Store(initialState: AppState(), reducer: appReducer, environment: Enviroment()))

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            IconButton(systemName: "line.horizontal.3", viewStore:mockViewStore, actions: [])
            Spacer()
            IconButton(systemName: "gear", viewStore:mockViewStore, actions: [],title: "Settings")
            Spacer()
            IconButton(systemName: "eye", viewStore:mockViewStore, actions: [],title: "Explore")
            Spacer()
            IconButton( systemName: "lightbulb", viewStore:mockViewStore, actions: [],title: "Hint")
            Spacer()
        }
        
    }
}
