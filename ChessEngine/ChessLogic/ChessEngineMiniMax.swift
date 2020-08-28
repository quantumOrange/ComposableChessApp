//
//  ChessEngineMiniMax.swift
//  Chess
//
//  Created by David Crooks on 12/10/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation


func pickMoveMiniMax(for board:Chessboard, depth:Int) -> ChessMove? {
    return miniMaxRoot(for: board, depth: depth)
}


func miniMaxRoot(for board:Chessboard, depth:Int) -> ChessMove? {
    
    /*
    let moves = validMoves(chessboard:board)
    var bestMoveValue:Float = -9999.0;
    var bestMove:ChessMove? = nil
    var mutableBoard = board
    for move in moves {
        mutableBoard.apply(move: move)
        let value = miniMax(for: &mutableBoard,
                            alpha:-10000,
                            beta:10000,
                            depth: depth,
                            isMaximisingPlayer:isMaximisingPlayer )
        _ = mutableBoard.undo()
        if value >= bestMoveValue {
                    bestMove = move;
                    bestMoveValue = value;
                }
    }
    */
    let moves = validMoves(chessboard:board)
    let playerTurn = board.whosTurnIsItAnyway;
    var mutableBoard = board
   // let isMaximisingPlayer = playerTurn == .white
    /*
    let values = moves
                    .map{ move -> Chessboard in
                        var mutableBoard =  board
                        mutableBoard.apply( move: move)
                            return mutableBoard
                    }
                    .map{ immutableBoard -> Float in
                            var mutableBoard = immutableBoard
                            return miniMax(for: &mutableBoard,
                                           alpha:-10000,
                                           beta:10000,
                                           depth: depth,
                                           player:!playerTurn )
 
                        }
     */
    var values:[Float] = []
    
    for move in moves {
        mutableBoard.apply( move: move)
        let newValue = miniMax(for: &mutableBoard,
                                alpha:-10000,
                                beta:10000,
                                depth: depth,
                                player:!playerTurn)
        values.append(newValue)
        
        _ = mutableBoard.undo()
    }
   
    
   
    let evaluatedMoves = zip(moves, values)
    /*
    print("----------------------------------------------------------")
    let sortedMoves = evaluatedMoves.sorted(by: {  $0.1 >  $1.1 } )
    for pair in sortedMoves {
        let (move,value) = pair
        print("\(move):\(value)")
    }
    print("----------------------------------------------------------")
    */
    let result:(ChessMove,Float)?
    
    switch playerTurn {
    case .white:
        //white wants the highest score == maximizing Player
        result = evaluatedMoves.max(by:{ $0.1 < $1.1})
    case .black:
        //black wants the lowests score == minimizeing Player
        result =  evaluatedMoves.min(by:{ $0.1 < $1.1})
    }
    
    
    if let (bestMove,_) = result {
        return bestMove
    }
    else {
        print("NO MOVE FOUND")
        return nil
    }
}

func miniMax(for board:inout Chessboard, alpha:Float, beta:Float, depth:Int,  player:PlayerColor) -> Float {

    let hasKing = board.squares(with: ChessPiece(player: board.whosTurnIsItAnyway, kind: .king, id:0)).count == 1;
    if !hasKing {
        // return board.quickValue
       return board.evaluate()
    }
    
    let moves = uncheckedValidMoves(chessboard:board)
    
    if moves.count == 0 {
        //print("there are no valid moves for \(board.whosTurnIsItAnyway)")
         return board.quickValue
       // return board.evaluate()
    }
    
    if depth == 0   {
        return board.quickValue
        //return board.evaluate()
    }
    
    var alpha = alpha
    var beta = beta
    
    
    switch player {
    
    case .white:
        var  bestMove:Float = -9999.0;
              
              for move in  moves {
                  board.apply(move: move)
                  
                  let minMaxValue = miniMax(for: &board, alpha:alpha, beta:beta, depth: depth-1, player: !player)
                
                
                  bestMove = max(bestMove,minMaxValue )
                  _  = board.undo()
                  
                  alpha = max(alpha,bestMove)
                  if(beta <= alpha){
                      return bestMove
                  }
              }
              
              return bestMove;
    case .black:
        var  bestMove:Float = 9999.0;
               
               for move in  moves {
                   board.apply(move: move)
                   
                   let miniMaxValue = miniMax(for: &board, alpha:alpha, beta:beta, depth: depth-1, player: !player)
                  
                   bestMove = min(bestMove, miniMaxValue)
                   _  =  board.undo()
                   
                   beta = min(beta,bestMove)
                   if(beta <= alpha){
                       return bestMove
                   }
               }
               
               return bestMove;
    }
    
    
   
}


