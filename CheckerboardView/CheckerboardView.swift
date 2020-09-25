//
//  ChessboardView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Combine


func absurd<A>(_ action:Never) -> A {}


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

public struct Checkerboard<Game:CheckerboardGame> : View {
    
    public init(store:Store<CheckerboardState<Game>,CheckerboardAction>) {
        self.store = store
    }
    
   let store: Store<CheckerboardState<Game>,CheckerboardAction>

    
    
    public var body: some View
        {
            WithViewStore(self.store)
            { viewStore in
                ZStack
                {
                   CheckerboardSquaresView(store:self.store.scope(state: { $0.checkerboardSquaresState }, action: absurd))
                    
                    PlacedPiecesView(store: self.store.scope(state:{ $0.placedPiecesState },action: absurd))
                    
                    TappableCheckersView(store: self.store.scope(state: { $0.tappableBoardState   }))
                }
            }
        }
}



/**********************************************************************/
/*                    PREVIEW                                    */
/**********************************************************************/

let mockCheckerBoardState = CheckerboardState<DefaultGame>(game:DefaultGame(),turn:.white,boardState: CheckerBoardUIState())

struct MockCheckerboardEnviroment: CheckerboardEnviromentProtocol {
    
    func subscribe() -> Effect<CheckerboardAction, Never> {
        return Effect.none
    }
    
    func playMove(move: Move) -> Effect<CheckerboardAction, Never> {
        return Effect.none
    }

}

let mockCheckerboardEnviroment = MockCheckerboardEnviroment()

let mockStore = Store(initialState: mockCheckerBoardState, reducer: defaultCheckerBoardReducer, environment: mockCheckerboardEnviroment)

struct CheckerboardView_Previews: PreviewProvider {
    static var previews: some View {
        Checkerboard(store: mockStore)
    }
}
