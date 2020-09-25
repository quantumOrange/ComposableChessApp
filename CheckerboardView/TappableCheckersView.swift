//
//  TappableCheckersView.swift
//  Chess
//
//  Created by David Crooks on 28/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


struct TappableBoardState:Equatable{
    var selectedSquare:CheckerboardSquare?
    var playerPointOfView:PlayerColor
}

struct TappableCheckersView: View {
    
    var store: Store<TappableBoardState,CheckerboardAction>
   
    var body: some View
    {
        WithViewStore(self.store)
        { viewStore in
            HStack(alignment: .center,spacing:0)
            {
                ForEach(files(orientatedFor:viewStore.state.playerPointOfView))
                {   file in
                    VStack(alignment: .center, spacing:0)
                    {
                        ForEach(ranks(orientatedFor:viewStore.state.playerPointOfView))
                        {   rank in

                            Button(action:{viewStore.send(.tap(CheckerboardSquare(rank:rank, file:file)))})
                            {
                                Rectangle()
                                    .stroke()
                                       // .fill(Color.blue)
                                    
                                    //Spacer().frame(width:self.squareWidth,height: self.squareWidth)
                            }
                            //.frame(width:self.squareWidth, height: self.squareWidth, alignment: .center)

                        }

                    }
                }
            }
            .aspectRatio(1,contentMode: .fit)
            //.animation(.easeInOut(duration: 0.3))
        }
    }
}

fileprivate let tappableBoardState = TappableBoardState(selectedSquare: nil, playerPointOfView: .white)
fileprivate let mockReducer = Reducer<TappableBoardState,CheckerboardAction,Void>{ state , action , env in
    
    return Effect.none
}
fileprivate let mockstore:Store<TappableBoardState,CheckerboardAction> = Store<TappableBoardState,CheckerboardAction>(initialState: tappableBoardState, reducer: mockReducer, environment: ())
struct TappableCheckersView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        TappableCheckersView(store:mockstore)
    }
}
