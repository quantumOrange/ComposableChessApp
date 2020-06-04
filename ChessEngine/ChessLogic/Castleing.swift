//
//  Castleing.swift
//  Chess
//
//  Created by David Crooks on 18/03/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation

enum CastleSide {
    case kingside
    case queenside
}

// print("kingside \(ChessboardSquare(code: "f1")!.id), \(ChessboardSquare(code: "f8")!.id)")
// print("queenside \(ChessboardSquare(code: "a1")!.id), \(ChessboardSquare(code: "a8")!.id)")
/*
 8   ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜
 7   ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟
 6   .  .  .  .  .  .  .  .
 5   .  .  .  .  .  .  .  .
 4   .  .  .  .  .  .  .  .
 3   .  .  .  .  .  .  .  .
 2   ♙  ♙  ♙  ♙  ♙  ♙  ♙  ♙
 1   ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖
     
     a  b  c  d  e  f  g  h
 */

let whiteKingSquare =  ChessboardSquare(code: "e1")!.int8Value
let blackKingSquare =  ChessboardSquare(code: "e8")!.int8Value


let whiteKingsideRookSquare = ChessboardSquare(code: "h1")!.int8Value
let blackKingsideRookSquare = ChessboardSquare(code: "h8")!.int8Value

let whiteQueensideRookSquare = ChessboardSquare(code: "a1")!.int8Value
let blackQueensideRookSquare = ChessboardSquare(code: "a8")!.int8Value

extension  Chessboard.CastelState {
    
    func canCastle(player:PlayerColor,on side:CastleSide)->Bool {
        switch player {
        
        case .white:
            switch side {
            case .kingside:
               return whiteCanCastleKingside
            case .queenside:
               return whiteCanCastleQueenside
            }
        case .black:
            switch side {
            case .kingside:
               return blackCanCastleKingside
            case .queenside:
               return blackCanCastleQueenside
            }
        }
    }
    
    mutating func setCanCastle(player:PlayerColor,on side:CastleSide ,to value:Bool){
        
        switch player {
        
        case .white:
            switch side {
            case .kingside:
               whiteCanCastleKingside = value
            case .queenside:
               whiteCanCastleQueenside = value
            }
        case .black:
            switch side {
            case .kingside:
               blackCanCastleKingside = value
            case .queenside:
               blackCanCastleQueenside = value
            }
        }
        
    }

    func movingPieces(changes:[ChessChange]) -> Chessboard.CastelState?
    {
        var newState = self
        
        let fromSquares = changes
            .map { $0.square }
        
        for sq in fromSquares {
            switch sq {
            case whiteKingSquare:
                newState.setCanCastle(player:.white, on: .kingside, to:false)
                newState.setCanCastle(player:.white, on: .queenside, to:false)
            case blackKingSquare:
                newState.setCanCastle(player:.black, on: .kingside, to:false)
                newState.setCanCastle(player:.black, on: .queenside, to:false)
            case whiteKingsideRookSquare:
                newState.setCanCastle(player:.white, on: .kingside, to:false)
            case whiteQueensideRookSquare:
                newState.setCanCastle(player:.white, on: .queenside, to:false)
            case blackKingsideRookSquare:
                newState.setCanCastle(player:.black, on: .kingside, to:false)
            case blackQueensideRookSquare:
                newState.setCanCastle(player:.black, on: .queenside, to:false)
            default:
                break
            }
        }
        /*
        
        for piece in pieces {
            
            
            
            switch piece.kind
            {
            case .king:
                newState.setCanCastle(player: piece.player, on: .kingside, to:false)
                newState.setCanCastle(player: piece.player, on: .queenside, to:false)
            case .rook:
                //kingside rooks have ids  56, 63
                //queenside rooks have ids 0, 7
                switch piece.id
                {
                case 0,7:
                    newState.setCanCastle(player: piece.player, on: .queenside, to:false)
                case 56,63:
                    newState.setCanCastle(player: piece.player, on: .kingside, to:false)
                default:
                    break
                }
            default:
                break
            }
        }
 */
        return newState
    }
    
}

extension ChessMove {
    init( player:PlayerColor,
          castleingSide:CastleSide,
          board:Chessboard = Chessboard.start()
          ) {
        
        //self.init(code:"")!
       /*
            Handy referance:
         
             8   ♜  .  .  .  ♚  .  .  ♜
             7   ♟  ♟  ♟  .  .  ♟  ♟  ♟
             6   .  .  .  .  .  .  .  .
             5   .  .  .  .  .  .  .  .
             4   .  .  .  .  .  .  .  .
             3   .  .  .  .  .  .  .  .
             2   ♙  ♙  ♙  .  .  ♙  ♙  ♙
             1   ♖  .  .  .  ♔  .  .  ♖
         
                 a  b  c  d  e  f  g  h
         
         
         
        
         
         
        
         */
        //self.auxillery = .none
        
        
        
        switch player {
        
        case .white:
            
            switch castleingSide {
                
            case .kingside:
                let rookSquare = whiteKingsideRookSquare
                let rookDestination:Int8 =  40// ChessboardSquare(code: "f1")!.int8Value  f1:40
                let kingDestination:Int8 =  48 //ChessboardSquare(code: "g1")!.int8Value  g1:48
                
              //  let rookMove = Move(from:rookSquare, to: rookDestination)
              // from = whiteKingSquare
             //  to = kingDestination
            // ChessChange(
               removeFirst = ChessChange( square: whiteKingSquare, piece: ChessPiece(player: .white, kind: .king, id: Int(whiteKingSquare)))
               removeSecond = ChessChange( square: rookSquare, piece: ChessPiece(player: .white, kind: .rook, id: Int(rookSquare)))
               addFirst = ChessChange( square: kingDestination, piece: ChessPiece(player: .white, kind: .king, id: Int(whiteKingSquare)))
               addSecond = ChessChange( square: rookDestination, piece: ChessPiece(player: .white, kind: .rook, id: Int(rookSquare)))
                //self.init(from:kingSquare,to:kingDestination,aux: .double(rookMove ))
            case .queenside:
                let rookSquare = whiteQueensideRookSquare
                //d1:24
               // c1:16
                let rookDestination:Int8 = 24 //ChessboardSquare(code: "d1")!.int8Value
                let kingDestination:Int8 = 16 //ChessboardSquare(code: "c1")!.int8Value
                
              //  let rookMove = Move(from:rookSquare, to: rookDestination)
                
               // self.auxillery = .double(rookMove )
                //self.init(from:kingSquare,to:kingDestination,aux: .double(rookMove ))
             //   from = whiteKingSquare
              // to = kingDestination
             
               removeFirst = ChessChange( square: whiteKingSquare, piece: ChessPiece(player: .white, kind: .king, id: Int(whiteKingSquare)))
               removeSecond = ChessChange( square: rookSquare, piece: ChessPiece(player: .white, kind: .rook, id: Int(rookSquare)))
               addFirst = ChessChange( square: kingDestination, piece: ChessPiece(player: .white, kind: .king, id: Int(whiteKingSquare)))
               addSecond = ChessChange( square: rookDestination, piece: ChessPiece(player: .white, kind: .rook, id: Int(rookSquare)))
            }
        case .black:
            
            switch castleingSide {
                
            case .kingside:
                let rookSquare = blackKingsideRookSquare
               // f8:47
               // g8:55
                let rookDestination:Int8 = 47// ChessboardSquare(code: "f8")!.int8Value
                let kingDestination:Int8 = 55// ChessboardSquare(code: "g8")!.int8Value
                
              //  let rookMove = Move(from:rookSquare, to: rookDestination)
                
               // self.auxillery = .double(rookMove )
                
              //  from = blackKingSquare
              // to = kingDestination
        
               removeFirst = ChessChange( square: blackKingSquare, piece: ChessPiece(player: .black, kind: .king, id: Int(blackKingSquare)))
               removeSecond = ChessChange( square: rookSquare, piece: ChessPiece(player: .black, kind: .rook, id: Int(rookSquare)))
               addFirst = ChessChange( square: kingDestination, piece: ChessPiece(player: .black, kind: .king, id: Int(blackKingSquare)))
               addSecond = ChessChange( square: rookDestination, piece: ChessPiece(player: .black, kind: .rook, id: Int(rookSquare)))
               // self.init(from:kingSquare,to:kingDestination,aux: .double(rookMove ))
            case .queenside:
                let rookSquare = blackQueensideRookSquare
               // d8:31
                //        c8:23
                let rookDestination:Int8 = 31 //ChessboardSquare(code: "d8")!.int8Value
                let kingDestination:Int8 =  23 //ChessboardSquare(code: "c8")!.int8Value
                
               // let rookMove = Move(from:rookSquare, to: rookDestination)
                
               // self.auxillery = .double(rookMove )
                
               // from = blackKingSquare
               // to = kingDestination
                
                removeFirst = ChessChange( square: blackKingSquare, piece: ChessPiece(player: .black, kind: .king, id: Int(blackKingSquare)))
                removeSecond = ChessChange( square: rookSquare, piece: ChessPiece(player: .black, kind: .rook, id: Int(rookSquare)))
                addFirst = ChessChange( square: kingDestination, piece: ChessPiece(player: .black, kind: .king, id: Int(blackKingSquare)))
                addSecond = ChessChange( square: rookDestination, piece: ChessPiece(player: .black, kind: .rook, id: Int(rookSquare)))
               // self.init(from:kingSquare,to:kingDestination,aux: .double(rookMove ))
            }
        
            
           // self.castleStateChange = CastleStateChange(changes: [removeFirst,removeSecond!], initialState: board.castelState )
        }
        
    }
}
/*

let whiteKingSquare = ChessboardSquare(rank: whiteKingsrank, file: .e)
let whiteKingsRookSquare = ChessboardSquare(rank: whiteKingsrank, file: .h)
let whiteQueensRookSquare = ChessboardSquare(rank: whiteKingsrank, file: .a)
 
 
 let whiteKingSquare =  ChessboardSquare(code: "e1")!
 let blackKingSquare =  ChessboardSquare(code: "e8")!


 let whiteKingsideRookSquare = ChessboardSquare(code: "h1")!
 let blackKingsideRookSquare = ChessboardSquare(code: "h8")!

 let whiteQueensideRookSquare = ChessboardSquare(code: "a1")!
 let blackQueensideRookSquare = ChessboardSquare(code: "a8")!
*/

let whiteKingsrank =  ChessRank._1
let whiteKingsideCastleSquares = [ChessboardSquare(rank:whiteKingsrank, file: .g),
                                  ChessboardSquare(rank:whiteKingsrank, file: .f)
                                  ,ChessboardSquare(rank:whiteKingsrank, file: .h)]


let whiteQuensideCastleSquares = [ChessboardSquare(rank:whiteKingsrank, file: .a),
                                    ChessboardSquare(rank:whiteKingsrank , file: .b),
                                    ChessboardSquare(rank:whiteKingsrank , file: .c),
                                    ChessboardSquare(rank:whiteKingsrank, file: .d)]


let blackKingsrank =  ChessRank._8
let blackKingsideCastleSquares = [ChessboardSquare(rank:blackKingsrank, file: .g),
                                  ChessboardSquare(rank:blackKingsrank, file: .f)
                                  ,ChessboardSquare(rank:blackKingsrank, file: .h)]


let blackQuensideCastleSquares = [ChessboardSquare(rank:blackKingsrank, file: .a),
                                    ChessboardSquare(rank:blackKingsrank , file: .b),
                                    ChessboardSquare(rank:blackKingsrank , file: .c),
                                    ChessboardSquare(rank:blackKingsrank, file: .d)]


let whiteCastelKingside = ChessMove(player:.white, castleingSide: .kingside)
let blackCastelKingside = ChessMove(player:.black, castleingSide: .kingside)
let whiteCastelQueenside = ChessMove(player:.white, castleingSide: .queenside)
let blackCastelQueenside = ChessMove(player:.black, castleingSide: .queenside)


func validCastles(board:Chessboard) -> [ChessMove] {
    
    /*
       Handy referance:
    
        8   ♜  .  .  .  ♚  .  .  ♜
        7   ♟  ♟  ♟  .  .  ♟  ♟  ♟
        6   .  .  .  .  .  .  .  .
        5   .  .  .  .  .  .  .  .
        4   .  .  .  .  .  .  .  .
        3   .  .  .  .  .  .  .  .
        2   ♙  ♙  ♙  .  .  ♙  ♙  ♙
        1   ♖  .  .  .  ♔  .  .  ♖
    
            a  b  c  d  e  f  g  h
    
    */
    
    let castleState = board.castelState
    let player = board.whosTurnIsItAnyway
    let opponent = !player
    
    let white = (player == .white)
    let kingSquare = white ? whiteKingSquare : blackKingSquare
    
    if(board[kingSquare]?.kind != .king) {
       // print("\(player)  King has moved -> no castles")
        return []
    }
    
 //   let rank = (player == .white) ? ChessRank._1 : ChessRank._8
    /*
    let kingSquare = ChessboardSquare(rank: rank, file: .e)
    let kingsRookSquare = ChessboardSquare(rank: rank, file: .h)
    let queensRookSquare = ChessboardSquare(rank: rank, file: .a)
    */
    
    let kingsRookSquare = white ? whiteKingsideRookSquare : blackKingsideRookSquare
    let queensRookSquare = white ? whiteQueensideRookSquare : blackQueensideRookSquare
    
    
    
    
    
    var moves:[ChessMove]  = []
    
    if castleState.canCastle(player: player,on:.kingside) && board[kingsRookSquare]?.kind == .rook {
          /*
           let castleSquares = [ChessboardSquare(rank:rank , file: .g),
                                   ChessboardSquare(rank:rank , file: .f)
                                   ,ChessboardSquare(rank:rank , file: .h)]
           */
        
        let castleSquares = white ? whiteKingsideCastleSquares : blackKingsideCastleSquares
        
           let piecesIntheMiddle = castleSquares
                                           .dropLast()
                                           .compactMap{board[$0]}
           
           
           let notControlled  = castleSquares.allSatisfy{!isControlled(square: $0, by: opponent, on: board)}
           
           let canCastle = piecesIntheMiddle.count == 0 && notControlled
           
           if canCastle  {
            if isInCheck(chessboard: board, player:player ) {
               // print(" \(player) King in Check -> no castles")
                return []
            }
           // print(" \(player) kingside castle")
            moves.append(white ? whiteCastelKingside : blackCastelKingside)
           }
       
       }
       
       if castleState.canCastle(player:player, on:.queenside) && board[queensRookSquare]?.kind == .rook{
          /*
           let castleSquares = [ChessboardSquare(rank:rank , file: .a),
                                ChessboardSquare(rank:rank , file: .b),
                                 ChessboardSquare(rank:rank , file: .c),
                                 ChessboardSquare(rank:rank , file: .d)]
               
               */
        let castleSquares =  white ? whiteQuensideCastleSquares : blackQuensideCastleSquares
        
           let piecesIntheMiddle = castleSquares
                                           .dropFirst()
                                           .compactMap{board[$0]}
           
           let notControlled  = castleSquares.allSatisfy{!isControlled(square: $0, by: opponent, on: board)}
           
           let canCastle = piecesIntheMiddle.count == 0 && notControlled
           
           if canCastle  {
            if isInCheck(chessboard: board, player:player ) {
              //  print(" \(player) King in Check -> no castles")
                return []
            }
           // print(" \(player) queenside castle")
            moves.append(white ? whiteCastelQueenside : blackCastelQueenside )
           }
          
       }
    return moves
}
