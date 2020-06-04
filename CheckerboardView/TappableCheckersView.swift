//
//  TappableCheckersView.swift
//  Chess
//
//  Created by David Crooks on 28/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//
//import DCArchitecture
import SwiftUI
import ComposableArchitecture
//import Chess

struct TappableBoardState:Equatable{
    var selectedSquare:CheckerboardSquare?
    var playerPointOfView:PlayerColor
}

struct TappableCheckersView: View {
    
    var store: Store<TappableBoardState,CheckerboardAction>
    
    let width:CGFloat
    
    var squareWidth:CGFloat {
        return width/8.0
    }
    
    var body: some View
    {
        WithViewStore(self.store)
        { viewStore in
            HStack(alignment: .center,spacing:0)
            {
                ForEach(files(orientatedFor:viewStore.state.playerPointOfView))
                { file in
                       VStack(alignment: .center, spacing:0)
                       {
                        ForEach(ranks(orientatedFor:viewStore.state.playerPointOfView)) { rank in
                               
                                           Button(action:{
                                            print("Tapped")
                                            viewStore.send(.tap(CheckerboardSquare(rank:rank, file:file)))
                                           
                                           } ){
                                            Spacer().frame(width:self.squareWidth,height: self.squareWidth)
                                               }
                                           .frame(width:self.squareWidth, height: self.squareWidth, alignment: .center)
                               
                                           }
                              
                       }
                }
            }.animation(.easeInOut(duration: 0.3))
        }
    }
}


struct TappableCheckersView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
