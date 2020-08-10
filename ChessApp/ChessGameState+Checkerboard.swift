//
//  CheckerboardGlue.swift
//  ChessApp
//
//  Created by David Crooks on 10/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//
import CheckerboardView
import ChessEngine
import Foundation

extension CheckerboardSquare {
    var chessboardSquare:ChessboardSquare {
        int8Value.chessboardSquare
    }
}

extension Int8 {
    public var checkerboardSquare:CheckerboardSquare {
        CheckerboardSquare(rank: Int(self) % 8, file: Int(self) / 8)
    }
}

extension ChessGameState:CheckerboardGame {
    public var placedPieces: [PlacedCheckerPiece<ChessPiece>] {
         board.positionPieces.map {
            PlacedCheckerPiece(piece: $0.1, square: $0.0.boardSquare)
        }
    }
    
    public mutating func applyMove(move: CheckerboardView.Move) -> Bool {
        guard let mv = ChessEngine.Move(from:move.from.int8Value,to:move.to.int8Value) else { return false }
        return  applyMoveIfValid(board:&board, move:mv)
    }
    
    public func validDestinationSquares(for selected: CheckerboardSquare) -> [CheckerboardSquare] {
        return validMoves(chessboard: board, square: selected.chessboardSquare, includeCastles: true)
            .map{ $0.to.checkerboardSquare}
    }
    
    public typealias Piece = ChessPiece
    
}
