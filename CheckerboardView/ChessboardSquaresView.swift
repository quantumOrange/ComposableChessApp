//
//  ChessboardSquaresView.swift
//  Chess
//
//  Created by david crooks on 22/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import ComposableArchitecture
import SwiftUI


struct CheckerboardSquaresState:Equatable {
    var possibleDestinationSquares:[CheckerboardSquare] = []
    var selectedSquare:CheckerboardSquare?
    var playerPointOfView:PlayerColor 
    let checkerColors:CheckerColors
    
    func color(rank:Int,file:Int) -> Color {
    
        let square = CheckerboardSquare(rank:rank, file:file)
        
       let couldMoveToSquare = possibleDestinationSquares.contains(square)
        if (selectedSquare == square){
            return checkerColors.selectedSquare
        }
        else if (couldMoveToSquare){
            return checkerColors.highlightSquares
        }
        else {
            return checkerColors.at(rank: rank, file: file)
        }

    }
}

struct CheckerboardSquaresView: View
{
    
    let store: Store<CheckerboardSquaresState,Never>
        
    var body: some View
    {
        WithViewStore(self.store)
        {   viewStore in

            HStack(alignment: .center,spacing:0)
            {

                ForEach(files(orientatedFor:viewStore.state.playerPointOfView))
                {   file in
                        
                    VStack(alignment: .center, spacing:0)
                    {
                        ForEach(ranks(orientatedFor:viewStore.state.playerPointOfView))
                        {   rank in
                            Rectangle()
                                .fill(viewStore.state.color(rank: rank, file: file))
                        }
                    }
                        
                }
            }.animation(.easeInOut(duration: 2.0))

        }
        .aspectRatio(1, contentMode: .fit)
                    
    }
}


let nullReducer = Reducer<CheckerboardSquaresState,Never,Void>{ _ , _ , _ in .none }

let mockCheckerboardSquaresState = CheckerboardSquaresState(possibleDestinationSquares: [CheckerboardSquare(rank: 1, file: 2),
                                                                                         CheckerboardSquare(rank: 3, file: 5)], selectedSquare: CheckerboardSquare(rank: 2, file: 3), playerPointOfView: .white, checkerColors: CheckerColors.defaultColors)

struct ChessboardSquaresView_Previews: PreviewProvider {
    static var previews: some View {
        CheckerboardSquaresView(store: Store(initialState: mockCheckerboardSquaresState, reducer: nullReducer, environment: ()))
    }
}
