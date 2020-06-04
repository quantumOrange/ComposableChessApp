//
//  ChessboardView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//
//import DCArchitecture
import ComposableArchitecture
import SwiftUI
import Combine
//import Chess
/*
func idAction(_ a:ChessboardAction) -> ChessboardAction {
    return a
}

func idState(_ v:CheckerboardState) -> CheckerboardState {
    return v
}
*/

func absurd<A>(_ action:Never) -> A {
    
}


extension CheckerboardState {
    var checkerboardSquaresState:CheckerboardSquaresState {
        CheckerboardSquaresState(possibleDestinationSquares:possibleDestinationSquares , selectedSquare: selectedSquare, playerPointOfView: playerPointOfView)
    }
    
    var tappableBoardState:TappableBoardState {
        TappableBoardState(selectedSquare: selectedSquare, playerPointOfView: playerPointOfView)
    }
    
    var placedPiecesState:PlacedPiecesState<Piece> {
        PlacedPiecesState(placedPieces: placedPieces, pointOfView: playerPointOfView)
    }
}

public struct BoardView<Piece:PieceViewRepresenable> : View {
    
    public init(store:Store<CheckerboardState<Piece>,CheckerboardAction>,width:CGFloat) {
        self.store = store
        self.width = width
    }
    
   let store: Store<CheckerboardState<Piece>,CheckerboardAction>
  
    let width:CGFloat
    
    
    public var body: some View
        {
            WithViewStore(self.store)
            { viewStore in
                ZStack
                {
                   CheckerboardSquaresView(store:self.store.scope(state: { $0.checkerboardSquaresState }, action: absurd) , width: self.width)
                    
                    PlacedPiecesView(store: self.store.scope(state:{ $0.placedPiecesState },action: absurd), width: self.width)
                    
                    TappableCheckersView(store: self.store.scope(state: { $0.tappableBoardState   }), width: self.width )
                }
            }
        }
}



let mockCheckerBoardState = CheckerboardState<DefaultPiece>(placedPieces:[pp1,pp2,pp3,pp4])

public let mockCheckerboardEnviroment = CheckerboardEnviroment(playMove: { move in
    
    return Effect(value: .clear)
}, selected: { square in
    return Effect(value: .validDestinationSquares([]))
})

let mockStore = Store(initialState: mockCheckerBoardState, reducer: checkerBoardReducer, environment: mockCheckerboardEnviroment)

struct CheckerboardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(store: mockStore, width: 300)
    }
}
