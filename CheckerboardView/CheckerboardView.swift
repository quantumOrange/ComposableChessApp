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
        CheckerboardSquaresState(possibleDestinationSquares:boardState.validDestinationSquares , selectedSquare: boardState.selectedSquare, playerPointOfView: boardState.playerPointOfView)
    }
    
    var tappableBoardState:TappableBoardState {
        TappableBoardState(selectedSquare: boardState.selectedSquare, playerPointOfView: boardState.playerPointOfView)
    }
    
    var placedPiecesState:PlacedPiecesState<Game.Piece> {
        PlacedPiecesState(placedPieces: game.placedPieces, pointOfView: boardState.playerPointOfView)
    }
}

public struct BoardView<Game:CheckerboardGame> : View {
    
    public init(store:Store<CheckerboardState<Game>,CheckerboardAction>,width:CGFloat) {
        self.store = store
        self.width = width
    }
    
   let store: Store<CheckerboardState<Game>,CheckerboardAction>
  
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



let mockCheckerBoardState = CheckerboardState<DefaultGame>(game:DefaultGame(),turn:.white,boardState: BoardState())


//public let mockCheckerboardEnviroment = CheckerboardEnviroment(
struct MockCheckerboardEnviroment: CheckerboardEnviromentProtocol {
    
    func subscribe() -> Effect<CheckerboardAction, Never> {
        return Effect.none
    }
    
    func playMove(move: Move) -> Effect<CheckerboardAction, Never> {
        return Effect.none
    }

}
let mockCheckerboardEnviroment = MockCheckerboardEnviroment()
/*Game
let mockCheckerboardEnviroment = CheckerboardEnviroment(playMove: { move in
    
    return Effect(value: .clear)
}, selected: { square in
    return Effect(value: .validDestinationSquares([]))
})
*/
let mockStore = Store(initialState: mockCheckerBoardState, reducer: defaultCheckerBoardReducer, environment: mockCheckerboardEnviroment)

struct CheckerboardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(store: mockStore, width: 300)
    }
}
