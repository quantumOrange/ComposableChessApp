//
//  ActionButton.swift
//  ChessApp
//
//  Created by David Crooks on 24/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ActionButton:View
{
    let title:String
    let viewStore: ViewStore<AppState,AppAction>
    let actions:[AppAction]

    var body: some View
    {
        Button(action:{ actions.forEach{viewStore.send($0)} }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(buttonBackgroundColor)
                
                Text(title)
                    .foregroundColor(buttonTextColor)
            }
        })
    }
    
    let cornerRadius:CGFloat = 25.0
    let buttonBackgroundColor = AppColorScheme.insetBackgroundColor
    let buttonTextColor = AppColorScheme.textColor
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "New Game", viewStore: ViewStore(Store(initialState: AppState(), reducer: appReducer, environment: Enviroment())), actions: [])
    }
}
