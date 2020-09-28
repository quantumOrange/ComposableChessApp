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
    
    
    let store: Store<(),AppAction>
    
    var body: some View {
        WithViewStore(self.store)
        {   viewStore in
            Button(action: {viewStore.send(AppAction.chessGame(.resign(.white)))} , label: {
                VStack {
                    
                    Text("♔")
                        .rotationEffect(Angle(degrees: 45))
                        .font(Font.largeTitle)
                    
                }

            })
        }
    }
    
    let buttonBackgroundColor = AppColorScheme.insetBackgroundColor
    let buttonTextColor = AppColorScheme.textColor
}

fileprivate let store = Store(initialState: (), reducer:Reducer<(),AppAction,()>{_,_,_ in Effect.none }, environment: ())
struct ResignButton_Previews: PreviewProvider {
    static var previews: some View
    {
        ResignButton(store:store)
    }
}
