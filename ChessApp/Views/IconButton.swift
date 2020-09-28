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
    
    init(systemName: String, store:Store<(),AppAction>, actions: [AppAction],title:String? = nil){
        self.title = title
        self.actions = actions
        self.store = store
        self.systemName = systemName
    }
    
    let title:String?
    let systemName:String
    let store: Store<(),AppAction>
    let actions:[AppAction]
    
    var body: some View {
        WithViewStore(self.store)
        {   viewStore in
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
    }
    
    let buttonBackgroundColor = AppColorScheme.insetBackgroundColor
    let buttonTextColor = AppColorScheme.textColor
}

fileprivate let store = Store(initialState: (), reducer:Reducer<(),AppAction,()>{_,_,_ in Effect.none }, environment: ())
struct IconButton_Previews: PreviewProvider {
    
    static var previews: some View {
        
        HStack {
            
            Spacer()
            IconButton(systemName: "line.horizontal.3", store:store, actions: [])
            Spacer()
            IconButton(systemName: "equal.circle", store:store, actions: [],title: "Settings")
            Spacer()
            IconButton(systemName: "eye", store:store, actions: [],title: "Explore")
            Spacer()
            IconButton( systemName: "lightbulb", store:store, actions: [],title: "Hint")
            Spacer()
        }
        
    }
}
