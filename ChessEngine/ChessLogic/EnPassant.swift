//
//  EnPassant.swift
//  Chess
//
//  Created by David Crooks on 24/03/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
extension ChessMove {
    init?(enPassant origin:Int8, on board:Chessboard){
        let fromSquare = origin
       /*

            8   ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
            7   ♟  .  ♟  ♟  ♟  ♟  .  ♟
            6   .  .  .  .  .  .  .  .
            5   .  ♟  ♙  .  .  .  .  .
            4   .  .  .  .  .  ♙  ♟  .
            3   .  .  .  .  .  .  .  .
            2   ♙  ♙  .  ♙  ♙  .  ♙  ♙
            1   ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖
                
                a  b  c  d  e  f  g  h

        */
        guard let lastMove = board.moves.last
            else { return nil }
        
        let takeSquare = lastMove.to
        var moveTo:Int8?
        
        guard   let pieceToMove = board[fromSquare],
                let pieceToTake = board[takeSquare],
                pieceToMove.kind == .pawn,
                pieceToTake.kind == .pawn
                                        else { return  nil }
        
        //white
        switch board.whosTurnIsItAnyway {
        case .white:
            if fromSquare.rank  == 4 && lastMove.from.rank == 6 && lastMove.to.rank == 4
               {
                  // takeSquare = lastMove.to
                   
                   if  let to =  fromSquare.getNeighbour(.topRight) ,
                       to.file == takeSquare.file
                   {
                      moveTo = to
                      //return ChessMove(from:square,to:to, on:board, aux:.take(takeSquare))
                   }
                   
                   if let to = fromSquare.getNeighbour(.topLeft),
                       to.file == takeSquare.file
                   {
                    moveTo = to
                    // return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
                   }
               }
        case .black:
            if fromSquare.rank  == 3 && lastMove.from.rank == 1 && lastMove.to.rank == 3
            {
               // let takeSquare = lastMove.to
                
                if  let to =  fromSquare.getNeighbour(.bottomRight),
                    to.file == takeSquare.file
                {
                   moveTo = to
                    // return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
                }
                else if let to = fromSquare.getNeighbour(.bottomLeft),
                    to.file == takeSquare.file
                {
                    moveTo = to
                    // return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
                }
               
            }
          
        }
        guard let movePieceTo = moveTo else { return nil }
        /*
        //self.from = fromSquare
       // self.to = movePieceTo
        
        changes.append(ChessChange(type: .remove , square: fromSquare, piece:pieceToMove))
        changes.append(ChessChange(type: .remove , square: takeSquare, piece:pieceToTake))
        changes.append(ChessChange(type: .add , square:movePieceTo, piece:pieceToMove))
 
 */
        removeFirst = ChessChange( square: fromSquare, piece:pieceToMove)
        removeSecond = ChessChange( square: takeSquare, piece:pieceToTake)
        addFirst = ChessChange(square:movePieceTo, piece:pieceToMove)
        addSecond = nil
        
       
    }
}
