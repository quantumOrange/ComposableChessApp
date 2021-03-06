//
//  ChessboardView.swift
//  Chess
//
//  Created by David Crooks on 01/06/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import SwiftUI
import CheckerboardView
import ChessEngine
import ComposableArchitecture

//et chessBoardSquareColors =

struct ChessboardView: View {
    let store: Store<CheckerboardState<ChessGameState>,CheckerboardAction>
    
    var body: some View {
        Checkerboard(store: self.store, getPieceView: ChessPieceView.init)
    }
}

/*************************************************/
/****************  Preview    ************************/
/*************************************************/


let board = Chessboard.start()

extension ChessboardSquare {
    var boardSquare:CheckerboardSquare {
        CheckerboardSquare(rank:Int(self.rank.rawValue), file:Int(self.file.rawValue))
    }
    //CheckerboardSquare(sqaure:ChessboardSquare)
}

let placedPieces = board.positionPieces.map {
    PlacedCheckerPiece(piece: $0.1, square: $0.0.boardSquare)
}
/*
let mockCheckerBoardState = CheckerboardState<ChessGameState>(placedPieces:placedPieces,turn: .white,boardState: BoardState())


let mockReducer  = Reducer<CheckerboardState<ChessPiece>, CheckerboardAction, CheckerboardEnviroment> { state, action, environment in
    .none
}

let mockStore = Store(initialState: mockCheckerBoardState, reducer: mockReducer, environment: mockCheckerboardEnviroment)

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(store: mockStore)
    }
}
*/
