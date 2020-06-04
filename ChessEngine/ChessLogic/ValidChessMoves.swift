//
//  ValidChessMoves.swift
//  Chess
//
//  Created by david crooks on 14/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation
func validate(chessboard:Chessboard, move:Move) -> ChessMove?
{
    guard let chessMove = ChessMove(from: move.from.int8Value, to: move.to.int8Value ,on:chessboard) else { return nil }
    return validate(chessboard: chessboard, move: chessMove)
}

func validate(chessboard:Chessboard, move:ChessMove) -> ChessMove? {
    
    guard let thePieceToMove = chessboard[move.from] else {
        //You can't move nothing
        return nil
    }
    
    if !isYourPiece(chessboard: chessboard, move: move) {
        return nil
    }
    
    if let thePieceToCapture = chessboard[move.to] {
        if thePieceToMove.player == thePieceToCapture.player {
            //you can't capture your own piece
            return nil
        }
    }
    
    func primaryMoveIsEqual(lhs:ChessMove,rhs:ChessMove) -> Bool {
        // Equal up to auxillary move (which is ignored)
        // User only indicates the primary move.
        return (lhs.from == rhs.from) && (lhs.to == rhs.to)
    }
    
    //return validMoves(chessboard: chessboard).contains(where: {primaryMoveIsEqual(lhs: $0, rhs: move)})
    return validMoves(chessboard: chessboard).first(where: {primaryMoveIsEqual(lhs: $0, rhs: move)})
}


func isValid(move:Move, on board:Chessboard) -> Bool {
    guard let chessMove = ChessMove(from: move.from.int8Value, to: move.to.int8Value, on: board) else { return false }
    return isValid(move: chessMove, on: board)
}

func isValid(move:ChessMove, on board:Chessboard) -> Bool {
  
    validMoves(chessboard:board).contains(move)
}


func validMoves(chessboard:Chessboard) -> [ChessMove] {
    var moves =  uncheckedValidMoves(chessboard: chessboard)
            .filter {
                !isInCheck(chessboard:apply(move: $0, to:chessboard ), player: chessboard.whosTurnIsItAnyway)
                    }
    
    moves.append(contentsOf: validCastles(board: chessboard))
    
    return moves
}



/*
    Not checked for check!
*/


func uncheckedValidMoves(chessboard:Chessboard) -> [ChessMove] {
    var moves:[ChessMove] = []
    /*
    for square in chessboard.squares {
        moves += validMoves(chessboard: chessboard, for: square)
    }
    */
    let range:Range<Int8> = 0..<64
    
    for square in range {
      //  moves += validMoves(chessboard: chessboard, for: square)
         moves += validMoves(chessboard: chessboard, square: square)
    }
    
    return moves
}


func isInCheck(chessboard:Chessboard, player:PlayerColor) -> Bool {
    
    var board = chessboard
    guard let kingSquare:ChessboardSquare = board.squares(with: ChessPiece(player: player, kind:.king,id:-1)).first else { return false }
   // guard let kingSquare:ChessboardSquare = board.squares(with: ChessPiece(player: player, kind:.king,id:-1)).first else { fatalError() }
    
    if player == board.whosTurnIsItAnyway  {
        //If we are looking to see if the current players king is in check, we need the other players moves
        //So we flip player with a null move
        //board = apply(move:ChessMove.nullMove, to: board)
        board.toggleTurn()
    }
     
    let enemyMoves = uncheckedValidMoves(chessboard:board)
    
    let movesThatAttackTheKing = enemyMoves.filter { $0.to.chessboardSquare == kingSquare }
        
    return !movesThatAttackTheKing.isEmpty
    
}

func isControlled(square:ChessboardSquare, by player:PlayerColor, on chessboard:Chessboard) -> Bool {
    
    var board = chessboard

    //guard let kingSquare:ChessboardSquare = board.squares(with: ChessPiece(player: player, kind:.king,id:-1)).first else { fatalError() }
    
    if player != board.whosTurnIsItAnyway  {
        //If we are looking to see if the current players square is in check, we need the other players moves
        //So we flip player with a null move
        //board = apply(move:ChessMove.nullMove, to: board)
        board.toggleTurn()
    }
     
    let playerMoves = uncheckedValidMoves(chessboard:board)
    
    let movesThatAttackTheSquare = playerMoves.filter { $0.to.chessboardSquare == square }
        
    return !movesThatAttackTheSquare.isEmpty
    
}
//TODO: clean this up . Make valid move internal
public func validMoves(chessboard:Chessboard, square origin:ChessboardSquare, includeCastles:Bool = false) -> [ChessMove] {
    validMoves(chessboard:chessboard, square:origin.int8Value, includeCastles:includeCastles)
}


func validMoves(chessboard:Chessboard, square origin:Int8, includeCastles:Bool = false) -> [ChessMove] {
    guard let piece = chessboard[origin],
        piece.player == chessboard.whosTurnIsItAnyway
            else { return [] }
    
    switch piece.kind {
    
    case .pawn:
         return validPawnMoves(board: chessboard, square:origin)
    case .knight:
         return validKnightMoves(board: chessboard, square:origin)
    case .bishop:
         return validBishopMoves(board: chessboard, square: origin)
    case .rook:
         return validRookMoves(board: chessboard, square:origin)
    case .queen:
         return validQueenMoves(board: chessboard, square:origin)
    case .king:
         var kingMoves = validKingMoves(board: chessboard, square: origin)
         if( includeCastles ) {
            kingMoves += validCastles(board: chessboard )
        }
        return kingMoves
    }
    
}



func getAllMoves(on board:Chessboard, from square:ChessboardSquare, in direction:Direction)->[ChessMove]{
    return getAllMoves(on:board,from:square,currentSquare:square, in:direction)
}

func getAllMoves(on board:Chessboard,
                 from origin:ChessboardSquare ,
                 currentSquare square:ChessboardSquare,
                 in direction:Direction) -> [ChessMove] {
    
    if let toSquare = square.getNeighbour(direction) , let  mv = makeMove(board: board, from:origin , to: toSquare) {
        if let piece = board[toSquare], piece.player != board.whosTurnIsItAnyway {
            //This is an enemy piece, which we can take, but we can't go any further in this direction, so we terminate here.
            return [mv]
        }
        return getAllMoves(on:board,from:origin,currentSquare:toSquare, in:direction) + [mv]
    }
    else {
        // We cannot go any further in this direction, either becuase we have reached the edge of the board,
        // or because one of our own pieces is in the way.
        return []
    }
}

func makeMove(board:Chessboard, from:ChessboardSquare, to:ChessboardSquare) -> ChessMove? {
    
    guard  board.whosTurnIsItAnyway != board[to]?.player else  { return nil }
    
    return ChessMove(from: from.int8Value, to: to.int8Value, on:board)
}

func makePawnForwardMove(board:Chessboard, from:ChessboardSquare, to:ChessboardSquare) -> ChessMove? {
    //Pawns cannot take moving forward, so "to" square must be empty
    
    guard let player = board[from]?.player,  board[to] == nil,
        let move = ChessMove(from: from.int8Value, to: to.int8Value,on:board)
        else  { return nil }
   
    return promotePawnIfValid(move:move, player:player,board:board)
}

func promotePawnIfValid(move:ChessMove,player:PlayerColor, board:Chessboard) -> ChessMove {
    let farRank  = (player == .white ) ? ChessRank._8 : ChessRank._1
    
    if move.to.rank == Int8(farRank.rawValue) {
        if let prometedMove = ChessMove(from:move.from,to:move.to,on:board, promote:.queen) {
            return prometedMove
        }
    }
   
    return move
    
}

func makePawnTakingdMove(board:Chessboard, from:ChessboardSquare, to:ChessboardSquare?) -> ChessMove? {
    //Pawns can only take diagonaly, so "to" square must contain an enemy piece
    
    guard  let to = to,
        let piece = board[to],
         let player = board[from]?.player,
        board.whosTurnIsItAnyway != piece.player,
        let move = ChessMove(from: from.int8Value, to: to.int8Value,on:board)
            else  { return nil }
    
    return promotePawnIfValid(move:move, player:player, board: board)
}

func enPassant(board:Chessboard, square origin:Int8)->ChessMove? {
    return ChessMove(enPassant:origin, on: board)
    /*
  
    guard let lastMove = board.moves.last
        else { return nil }
    
    //white
    switch board.whosTurnIsItAnyway {
    case .white:
        if square.rank  == ._5 && lastMove.from.rank == ._7 && lastMove.to.rank == ._5
           {
               let takeSquare = lastMove.to
               
               if  let to =  square.getNeighbour(.topRight) ,
                   to.file == takeSquare.file
               {
                   return ChessMove(from:square,to:to, on:board, aux:.take(takeSquare))
               }
               
               if let to = square.getNeighbour(.topLeft),
                   to.file == takeSquare.file
               {
                    return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
               }
           }
    case .black:
        if square.rank  == ._4 && lastMove.from.rank == ._2 && lastMove.to.rank == ._4
        {
            let takeSquare = lastMove.to
            
            if  let to =  square.getNeighbour(.bottomRight),
                to.file == takeSquare.file
            {
                return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
            }
            
            if let to = square.getNeighbour(.bottomLeft),
                to.file == takeSquare.file
            {
                 return ChessMove(from:square,to:to,on:board, aux:.take(takeSquare))
            }
        }
      
    }
    
   
    
    return nil
 */
}

func validPawnMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
   
    var destinationSqs:[Int8] = []
   // let origin = square.int8Value
    
    let rank = origin.rank
    let file = origin.file
    
    // rank + 1 -> +1
    // file + 1 -> +8
  // sq = 8 * file + rank
    
    switch  board.whosTurnIsItAnyway {
    
    case .white:
        let moveForwardOne = origin + 1
        if board[moveForwardOne] == nil {
            destinationSqs.append(moveForwardOne)
            if rank == 1 {
                let moveForwardTwo = moveForwardOne + 1
                if board[moveForwardTwo] == nil {
                    destinationSqs.append(moveForwardTwo )
                }
            }
        }
        
        if file > 0
        {
            let takeLeft =  origin  -  7  //( -8 file, +1  rank  )
            if board[takeLeft]?.player  ==  .black
            {
                destinationSqs.append(takeLeft )
            }
        }
        
        if file < 7
        {
            let takeRight =  origin  +  9 //( +8 file, +1  rank  )
            if board[takeRight]?.player  ==  .black
            {
                destinationSqs.append(takeRight)
            }
        }
        
    case .black:
        let moveForwardOne = origin - 1
        if board[moveForwardOne] == nil {
            destinationSqs.append(moveForwardOne)
            if rank == 6 {
                let moveForwardTwo = moveForwardOne - 1
                if board[moveForwardTwo] == nil {
                    destinationSqs.append(moveForwardTwo )
                }
            }
        }
        
        if file > 0
               {
                   let takeLeft =  origin  -  9  //( -8 file, -1  rank  )
                   if board[takeLeft]?.player  ==  .black
                   {
                       destinationSqs.append(takeLeft )
                   }
               }
               
       if file < 7
       {
           let takeRight =  origin  +  7 //( +8 file, -1  rank  )
           if board[takeRight]?.player  ==  .black
           {
               destinationSqs.append(takeRight)
           }
       }
    }
    
    var  moves = destinationSqs
                .compactMap{ ChessMove(from: origin, to: $0, on: board ) }
    
    if let  enPassant = enPassant(board: board, square: origin){
         moves.append( enPassant)
    }
               
    return moves
   
  //  return []
    
    /*
    var moves:[ChessMove?] = []
    switch board.whosTurnIsItAnyway {
    
    case .white:
        if let sq1 = square.getNeighbour(.top) {
            let mv1 = makePawnForwardMove(board: board, from: square, to: sq1)
            moves.append(mv1)
            
            if let mv1 = mv1, square.rank == ._2 {
                if let sq2 = mv1.to.getNeighbour(.top) {
                    let mv2 = makePawnForwardMove(board: board, from: square, to: sq2)
                    moves.append(mv2)
                }
            }
        }
        
        //pawns take diagonally
        moves.append(makePawnTakingdMove(board: board, from: square, to:square.getNeighbour(.topRight)))
        moves.append(makePawnTakingdMove(board: board, from: square, to:square.getNeighbour(.topLeft)))
        
        
        
        
    case .black:
        
        if let sq1 = square.getNeighbour(.bottom) {
            let mv1 = makePawnForwardMove(board: board, from: square, to: sq1)
            moves.append(mv1)
            
            if let mv1 = mv1, square.rank == ._7 {
                if let sq2 = mv1.to.getNeighbour(.bottom) {
                    let mv2 = makePawnForwardMove(board: board, from: square, to: sq2)
                    moves.append(mv2)
                }
            }
        }
        
        
        
        //pawns take diagonally
        moves.append(makePawnTakingdMove(board: board, from: square, to:square.getNeighbour(.bottomRight)))
        moves.append(makePawnTakingdMove(board: board, from: square, to:square.getNeighbour(.bottomLeft)))
        
    }
    
    moves.append(enPassant(board: board, square: square))
    
    return moves.compactMap{$0}
    */
}

func validKnightMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
   /*

                                    8   .  *  .  *  .  .  .  .
                                    7   *  .  .  .  *  .  .  .
                                    6   .  .  ♘  .  .  .  .  .
                                    5   *  .  .  .  *  .  .  .
                                    4   .  *  .  *  *  .  *  .
                                    3   .  .  .  *  .  .  .  *
                                    2   .  .  .  .  .  ♞  .  .
                                    1   .  .  .  *  .  .  .  ♜
                                        
                                        a  b  c  d  e  f  g  h

                                    
                     //"b4" , "a5","d4","e5", "a7","b8","d8", "e7"
 */
    var destinationSqs:[Int8] = []
     //  let origin = square.int8Value
       
       let rank = origin.rank
       let file = origin.file
       
    if rank < 7
    {
        // rank + 1 -> +1
        if file < 6
        {
            // file + 2 -> +16
            destinationSqs.append( origin + 17 )
        }
        if file > 1
        {
            // file -2  -> -16
            destinationSqs.append( origin - 15 )
        }
        
        if  rank < 6
        {
            // rank + 2 -> +2
            if file < 7
            {
                // file + 1 -> +8
                destinationSqs.append( origin + 10 )
            }
            if file > 0
            {
                // file - 1 -> -8
                destinationSqs.append( origin - 6 )
            }
        }
    }
    
    if rank > 0
    {
        // rank - 1 -> -1
        if file < 6
        {
            // file + 2 -> +16
            destinationSqs.append( origin + 15 )
        }
        if file > 1
        {
            // file -2  -> -16
            destinationSqs.append( origin - 17 )
        }
        
        if  rank > 1
        {
            // rank - 2 -> -2
            if file < 7
            {
                // file + 1 -> +8
                 destinationSqs.append( origin  +  6 )
            }
            if file > 0
            {
                // file - 1 -> -8
                destinationSqs.append( origin  - 10 )
            }
        }
    }
    
    return destinationSqs
                 .filter  {  board[$0]?.player != board.whosTurnIsItAnyway }
                .compactMap{ ChessMove(from: origin, to: $0, on: board ) }
    
    
    
    /*
    var destionationSquares:[ChessboardSquare?] = []
    
    destionationSquares.append(square.getNeighbour(.top)?.getNeighbour(.top)?.getNeighbour(.left))
    destionationSquares.append(square.getNeighbour(.top)?.getNeighbour(.top)?.getNeighbour(.right))
    destionationSquares.append(square.getNeighbour(.bottom)?.getNeighbour(.bottom)?.getNeighbour(.left))
    destionationSquares.append(square.getNeighbour(.bottom)?.getNeighbour(.bottom)?.getNeighbour(.right))
    destionationSquares.append(square.getNeighbour(.left)?.getNeighbour(.left)?.getNeighbour(.top))
    destionationSquares.append(square.getNeighbour(.left)?.getNeighbour(.left)?.getNeighbour(.bottom))
    destionationSquares.append(square.getNeighbour(.right)?.getNeighbour(.right)?.getNeighbour(.top))
    destionationSquares.append(square.getNeighbour(.right)?.getNeighbour(.right)?.getNeighbour(.bottom))
    
    return destionationSquares
                .compactMap{$0}
                .compactMap{ makeMove(board: board, from: square, to: $0) }
   */
}
/*
extension Chessboard {
    var currentPlayersCastelState:CastelState {
        switch self.whosTurnIsItAnyway {
        case .white:
            return self.whiteCastelState
        case .black:
            return self.blackCastelState
        }
    }
}
*/
func validKingMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
    var destinationSqs:[Int8] = []
   // let origin = square.int8Value
    
    let rank = origin.rank
    let file = origin.file
    
    
    
       //topLeft         // - 7     // increase rank (+1) , decrease file (-8)     //  n =  min ( 7 - rank , file )
       //topRight        // + 9     // increase rank and file                      //  n =  min ( 7 - rank , 1-file )
       //bottomLeft      // - 9     // decrease rank and file                      //  n =  min ( rank , file )
       //bottomRight     // + 7     // decrease rank (-1) , increase file (+8)     //  n =  min (  rank , 1 - file )
    
     /*
     
     
                                     8   .  .  .  .  .  .  .  .
                                     7   .  *  *  *  .  .  .  .
                                     6   .  *  ♔  *  .  .  .  .
                                     5   .  *  *  *  .  .  .  .
                                     4   .  .  .  .  .  .  .  .
                                     3   .  .  .  .  .  .  .  .
                                     2   .  .  .  .  .  ♟  *  ♙
                                     1   .  .  .  .  .  *  ♚  *
                                         
                                         a  b  c  d  e  f  g  h
     */
    
    
    //above
    if rank < 7 {
        destinationSqs.append( origin + 1 )  // top +1
        if file > 0 {
            //let sq =  origin - 7
            destinationSqs.append( origin - 7 )  // top left
        }
        if file <  7 {
           // let sq =
            destinationSqs.append( origin + 9 )  // top right
        }
    }
    
    //below
    if rank > 0 {
        destinationSqs.append( origin - 1 )  // bottom -1
        if file > 0 {
            destinationSqs.append( origin - 9 )  // bottom left
        }
         if file <  7 {
            destinationSqs.append( origin + 7 )  // bottom right
        }
    }
    
    //middle
    if file > 0 {
        destinationSqs.append( origin - 8 )  // bottom left
    }
    if file < 7 {
        destinationSqs.append( origin + 8 )  // bottom right
    }
    
    return destinationSqs
                .filter  {  board[$0]?.player != board.whosTurnIsItAnyway }
                .compactMap{ ChessMove(from: origin, to: $0, on: board ) }
    
    /*
        let directions = ChessboardSquare.Direction.allCases
    
        return directions
                    .compactMap{square.getNeighbour($0)}
                    .compactMap{ makeMove(board: board, from: square, to: $0) }
    
    */
}



func validBishopMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
    var destinationSqs:[Int8] = []
    //topLeft         // - 7     // increase rank (+1) , decrease file (-8)     //  n =  min ( 7 - rank , file )
    //topRight        // + 9     // increase rank and file                      //  n =  min ( 7 - rank , 1-file )
    //bottomLeft      // - 9     // decrease rank and file                      //  n =  min ( rank , file )
    //bottomRight     // + 7     // decrease rank (-1) , increase file (+8)     //  n =  min (  rank , 1 - file )
    
    
  //  let origin   = square.int8Value
    //topLeft        // - 7
    //topRight      // + 9 //  //
                 //bottomLeft   // -9  //
                 //bottomRight    // 7
       
       var i = origin
    let rank:Int8 = origin.rank
    let file:Int8 = origin.file
    let inv_rank = 7 - rank
    let inv_file = 7 - file
    
    var n_moves = min(rank, inv_file)
    var n = 0
    
       while n < n_moves {
           i += 7
           n += 1
      //  rank = i.rank
     //   file = i.file
          // print(i)
           if let piece  = board[i] {
               if piece.player != board.whosTurnIsItAnyway {
                  // print(i)
                   destinationSqs.append(i)
               }
               break
           }
         //  print(i)
           destinationSqs.append(i)
           //assert( i >= 0  && i < 64  )
       }
      // while n < n_moves
       //while rank != 0 && rank != 7 && file != 0 && file != 7
    
       i = origin
    n_moves = min(inv_rank, file)
    n = 0
    
        while n < n_moves {
            i -= 7
             n += 1
       //  rank = i.rank
       //  file = i.file
           // print(i)
            if let piece  = board[i] {
                if piece.player != board.whosTurnIsItAnyway {
                   // print(i)
                    destinationSqs.append(i)
                }
                break
            }
          //  print(i)
            destinationSqs.append(i)
            //assert( i >= 0  && i < 64  )
        }
    //while n < n_moves
        //while rank != 0 && rank != 7 && file != 0 && file != 7
    
    
    i = origin
    n_moves = min(inv_rank, inv_file)
    n = 0
    
         while n < n_moves {
             i += 9
               n += 1
         // rank = i.rank
         // file = i.file
            // print(i)
             if let piece  = board[i] {
                 if piece.player != board.whosTurnIsItAnyway {
                    // print(i)
                     destinationSqs.append(i)
                 }
                 break
             }
           //  print(i)
             destinationSqs.append(i)
             //assert( i >= 0  && i < 64  )
         }
       //     while n < n_moves
         //while rank != 0 && rank != 7 && file != 0 && file != 7
    
    i = origin
    n_moves = min(rank, file)
    n = 0
         while n < n_moves {
            i -= 9
              n += 1
         //rank = i.rank
        // file = i.file
           // print(i)
            if let piece  = board[i] {
                if piece.player != board.whosTurnIsItAnyway {
                   // print(i)
                    destinationSqs.append(i)
                }
                break
            }
          //  print(i)
            destinationSqs.append(i)
            //assert( i >= 0  && i < 64  )
        }
       
      //  while rank != 0 && rank != 7 && file != 0 && file != 7
    
    
      return destinationSqs
                .compactMap{ ChessMove(from: origin, to: $0, on: board ) }
     // return []
   // let directions:[ChessboardSquare.Direction] = [.topLeft,.topRight,.bottomLeft,.bottomRight]
       
   // return directions.flatMap{ getAllMoves(on: board, from: square, in: $0)}
}


func validRookMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
    // i = file*8 + rank
  
    var destinationSqs:[Int8] = []
    
  //  let origin   = square.int8Value
    
    
   // let topEdge =   origin.file * 8  + 7  // rank = 7, file
  //  let bottomEdge =   origin.file * 8   // rank = 0,  file
  //  let leftEdge =   origin.rank  //rank ,  file = 0
  //  let rightEdge =   56  + origin.rank // rank ,  file = 7
    //origin.chessboardSquare
    
    //right  + 8
  //  print("Sqaure ??  \(origin)")
  //  print("--------- go right  +8 ----------------")
    let rightEdge =  56  + origin.rank
    var i = origin
    while i != rightEdge {
        i += 8
       // print(i)
        if let piece  = board[i] {
            if piece.player != board.whosTurnIsItAnyway {
               // print(i)
                destinationSqs.append(i)
            }
            break
        }
      //  print(i)
        destinationSqs.append(i)
        assert( i >= 0  && i < 64  )
    }
    //
    
    
   // print("--------- go left -8 ----------------")
    
    //-------------------------------
    //left - 8
    let leftEdge =  origin.rank
    
    i = origin
     while i != leftEdge {
        i -= 8
        
        if let piece  = board[i] {
            if piece.player != board.whosTurnIsItAnyway {
         //       print(i)
                destinationSqs.append(i)
            }
            break
        }
      //  print(i)
        destinationSqs.append(i)
        assert( i >= 0  && i < 64  )
    }
   
    
   //  print("--------- go up  +1 ----------------")
    //-------------------------------
    //top  + 1
    
    let topEdge = origin.file * 8 + 7
    
    i = origin
      while i != topEdge {
           i += 1
            
           if let piece  = board[i] {
               if piece.player != board.whosTurnIsItAnyway {
                //   print(i)
                   destinationSqs.append(i)
               }
               break
           }
         //  print(i)
           destinationSqs.append(i)
           assert( i >= 0  && i < 64  )
       }
      
    
  //  print("--------- go down  -1 ----------------")
    //-------------------------------
    //bottom  -1
    let bottomEdge = origin.file * 8
    
    i = origin
     while i != bottomEdge {
        i -= 1
        
        if let piece  = board[i] {
            if piece.player != board.whosTurnIsItAnyway {
             //   print(i)
                destinationSqs.append(i)
            }
            break
        }
       // print(i)
        destinationSqs.append(i)
        assert( i >= 0  && i < 64  )
    }
   
    
  return destinationSqs
        .compactMap{ ChessMove(from: origin, to: $0, on: board ) }
  //  return []
    
  // let directions:[ChessboardSquare.Direction] = [.bottom,.top,.left,.right]
    
    
   
   // return directions.flatMap{ getAllMoves(on: board, from: square, in: $0)}
}


func validQueenMoves(board:Chessboard, square origin:Int8) -> [ChessMove] {
    
    validRookMoves(board: board, square: origin) + validBishopMoves(board: board, square: origin)
   // let directions = ChessboardSquare.Direction.allCases
    
   // return directions.flatMap{ getAllMoves(on: board, from: square, in: $0)}
}




