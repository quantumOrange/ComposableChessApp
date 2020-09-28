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
    let store: Store<Void,AppAction>
    
    var body: some View {
        
            HStack {
               
                Spacer()
                IconButton( systemName: "line.horizontal.3", store:self.store, actions: [.nav(.setShowGameOptionsActionSheet(true))])
                Spacer()
                IconButton(systemName: "eye", store:self.store, actions: [.nav(.setShowExplore(true) )])
                Spacer()
                
            }
            .foregroundColor(AppColorScheme.textColor)
        
        
    }
}



/****************************************************************************/
/************************      Preview   ****************************************/
/***************************************************************************/


fileprivate let store = Store(initialState: (), reducer:Reducer<(),AppAction,()>{_,_,_ in Effect.none }, environment: ())
struct ChessControlView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        ChessControlView(store: store)
    }
}
