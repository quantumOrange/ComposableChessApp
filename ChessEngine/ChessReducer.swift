//
//  ChessMoveReducer.swift
//  Chess
//
//  Created by david crooks on 08/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//
//import DCArchitecture
import ComposableArchitecture
import Foundation

public enum ChessAction {
   
    
    case clear
    case chessMove(ChessMove)
    case move(Move)
    case resign(PlayerColor)
    case timeout(PlayerColor)
    case offerDraw(PlayerColor)
    case noValidMoves
    case nextTurn
    //case beginRemoteGame
    case playBothSides(Chessboard?)
    case playComputerAs(PlayerColor,Chessboard?)
    case setOnlineGame(Chessboard,PlayerColor)
    
    var move:Move? {
        guard case let .move(mv) = self else { return nil }
        return mv
    }
    
    var resign:PlayerColor? {
        guard case let .resign(player) = self else { return nil }
        return player
    }
    
    var offerDraw:PlayerColor? {
        guard case let .offerDraw(player) = self else { return nil }
        return player
    }
}

public enum ChessExoAction {
    case clear
    case sendTurn(Chessboard)
    case playingAs(PlayerColor)
    case gameBegan
}

public struct ChessGameState:Equatable {
    var gameHasBegun = false
    public var board:Chessboard =  Chessboard.start()
    public var players:PlayerTypes = PlayerTypes(white:.none, black: .none)
    
    public init() {
       // self.board = board
       // self.players = players
    }
}

public func applyMoveIfValid(board:inout Chessboard,move:Move)->Bool{
    guard let validatedMove = validate(chessboard:board, move:move) else { return false }
    
    board.apply(move:validatedMove)
    board.gamePlayState = gamePlayState(chessboard: board)
    return true
}

func moveAction(validated move:ChessMove, game:inout ChessGameState) -> Effect<ChessAction,Never>{
   print("We are appling \( game.board.whosTurnIsItAnyway)'s  move \(move)")
               let playerType =  game.players.player(for:game.board.whosTurnIsItAnyway)
               
               switch playerType {
               case .appUser:
                   print("This is a the local players move.")
               case .computer:
                   print("This is a computer move.")
               default:
                   assert(false, "Remote players (or none) \(playerType) shold not be applying moves. They should apply locally and send us the whole godamn board. ")
               }
               
             //  game.board =
               game.board.apply(move:move)
               game.board.gamePlayState = gamePlayState(chessboard: game.board)
    /*
    let clearEffect = Effect<ChessAction,Never>.catching({
                return .clear
               })
               
    let nextTurnEffect = Effect<ChessAction,Never>.catching({
                  return .nextTurn
               })
               
               let ce = clearEffect
                           .merge(with:nextTurnEffect)
                          // .eraseToEffect()
    
                let m = ce.eraseToEffect()
               */
    return .none
           }


public struct ChessEnviroment {
    public init(pickMove:@escaping (Chessboard) -> Effect<ChessAction,Never>,sendTurn:@escaping (Chessboard) -> Effect<ChessAction,Never>){
        self.pickMove = pickMove
       
        self.sendTurn = sendTurn
    }
    var pickMove:(Chessboard) -> Effect<ChessAction,Never>
    var sendTurn:(Chessboard) -> Effect<ChessAction,Never>
}

/*
let pickMoveEffect = Effect<ChessAction,Never >.run({ callback in
    
    DispatchQueue.global(qos: .background).async {
        print("This is run on the background queue")
        let move = pickMove(for:board)
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            if let move = move {
                
                callback(.endo(.chessMove(move)))
            }
            else {
                callback(.endo(.noValidMoves))
            }
        }
    }
    
})
*/

public let chessReducer = Reducer<ChessGameState,ChessAction,ChessEnviroment> { game, action , enviroment in
    
    switch action {
           
       case .chessMove(let move):
            if let validatedMove = validate(chessboard:game.board, move:move)
            {
               return moveAction(validated:validatedMove, game: &game)
            }
    
       case .move(let move):
          // print("kingside \(ChessboardSquare(code: "h1")!.id), \(ChessboardSquare(code: "h8")!.id)")
          // print("queenside \(ChessboardSquare(code: "a1")!.id), \(ChessboardSquare(code: "a8")!.id)")
           if let validatedMove = validate(chessboard:game.board, move:move) {
               return moveAction(validated:validatedMove, game: &game)
           }
       case .nextTurn:
           
           let playerType =  game.players.player(for:game.board.whosTurnIsItAnyway)
           
           switch playerType {
           case .none:
               //Mabe fatal error? what should we do here?
               print("Player type none! probaly bad")
               
               break
           case .appUser:
               //wait for user, nothing to do here
               print("It is now the local players turn, so we just need to wait for them to do something.")
               break
           case .remote:
               print("We must have just applied the local players move.")
               print("It is now the remote players turn, as far as we  are concerned.")
               print("We need to send the board to the gamecenter and pass  the turn to them.")
               //talk to game center
               //return Effect<Output<ChessAction,ChessExoAction>>.send(.exo(.sendTurn(game.board)))
               return enviroment.sendTurn(game.board)
           case .computer:
               let board = game.board
               return enviroment.pickMove(game.board)
              // return pickMoveEffect
               
           }

       case .offerDraw(_):
           game.board.gamePlayState = .draw
       case .resign(let player):
           game.board.gamePlayState = .won(!player)
       case .noValidMoves:
           game.board.gamePlayState = .draw
       case .timeout(let player):
           game.board.gamePlayState = .won(!player)
       case .setOnlineGame(let chessboard, let localPlayer):
           print("Setting the game to:")
           print(chessboard)
           game.board = chessboard
          // chessboard.moves.count.isMultiple(of: 2)
           switch localPlayer {
           case .white:
               game.players =   PlayerTypes(white: .appUser, black: .remote)
           case .black:
               game.players =  PlayerTypes(white:.remote, black: .appUser)
           }
          
           game.gameHasBegun = true
           
           //ChessExoAction.began
           /*
           let begin = Effect<Output<ChessAction,ChessExoAction>>.send(.exo(.gameBegan))
           return Effect
               .send(.exo(.playingAs(localPlayer)))
               .merge(with: begin)
               .eraseToEffect()
            */
           
       case .playComputerAs(let playerColor, let board ):
           game.board = board ?? Chessboard.start()
           //var effect
           switch playerColor {
           
           case .white:
               game.players = PlayerTypes(white: .appUser, black: .computer)
           case .black:
               game.players = PlayerTypes(white: .computer, black: .appUser)
              // return Effect.send(.endo(.nextTurn))
           }
           
       case .playBothSides(let board):
           
           game.board = board ?? Chessboard.start()
           game.players = PlayerTypes(white: .appUser, black: .appUser)
       case .clear:
           game.board = Chessboard.start()
           game.players = PlayerTypes(white: .none, black: .none)
       }
       
    
    
    return .none
}
    

/*
public func chessReducer2(_ game:inout ChessGameState,_ action:ChessAction) -> Effect<ChessAction,ChessExoAction> {

    switch action {
        
    case .chessMove(let move):
         if let validatedMove = validate(chessboard:game.board, move:move)
         {
            return moveAction(validated:validatedMove, game: &game)
         }
 
    case .move(let move):
        print("kingside \(ChessboardSquare(code: "h1")!.id), \(ChessboardSquare(code: "h8")!.id)")
        print("queenside \(ChessboardSquare(code: "a1")!.id), \(ChessboardSquare(code: "a8")!.id)")
        if let validatedMove = validate(chessboard:game.board, move:move) {
            return moveAction(validated:validatedMove, game: &game)
        }
    case .nextTurn:
        
        let playerType =  game.players.player(for:game.board.whosTurnIsItAnyway)
        
        switch playerType {
        case .none:
            //Mabe fatal error? what should we do here?
            print("Player type none! probaly bad")
            
            break
        case .appUser:
            //wait for user, nothing to do here
            print("It is now the local players turn, so we just need to wait for them to do something.")
            break
        case .remote:
            print("We must have just applied the local players move.")
            print("It is now the remote players turn, as far as we  are concerned.")
            print("We need to send the board to the gamecenter and pass  the turn to them.")
            //talk to game center
            return Effect<Output<ChessAction,ChessExoAction>>.send(.exo(.sendTurn(game.board)))
            
        case .computer:
            let board = game.board
            let pickMoveEffect = Effect<Output<ChessAction,ChessExoAction> >.async(work: { callback in
                
                DispatchQueue.global(qos: .background).async {
                    print("This is run on the background queue")
                    let move = pickMove(for:board)
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        if let move = move {
                            
                            callback(.endo(.chessMove(move)))
                        }
                        else {
                            callback(.endo(.noValidMoves))
                        }
                    }
                }
                
            })
            return pickMoveEffect
            
        }

    case .offerDraw(_):
        game.board.gamePlayState = .draw
    case .resign(let player):
        game.board.gamePlayState = .won(!player)
    case .noValidMoves:
        game.board.gamePlayState = .draw
    case .timeout(let player):
        game.board.gamePlayState = .won(!player)
    case .setOnlineGame(let chessboard, let localPlayer):
        print("Setting the game to:")
        print(chessboard)
        game.board = chessboard
       // chessboard.moves.count.isMultiple(of: 2)
        switch localPlayer {
        case .white:
            game.players =   PlayerTypes(white: .appUser, black: .remote)
        case .black:
            game.players =  PlayerTypes(white:.remote, black: .appUser)
        }
       
        game.gameHasBegun = true
        
        let begin = Effect<Output<ChessAction,ChessExoAction>>.send(.exo(.gameBegan))
        return Effect
            .send(.exo(.playingAs(localPlayer)))
            .merge(with: begin)
            .eraseToEffect()
        
    case .playComputerAs(let playerColor, let board ):
        game.board = board ?? Chessboard.start()
        //var effect
        switch playerColor {
        
        case .white:
            game.players = PlayerTypes(white: .appUser, black: .computer)
        case .black:
            game.players = PlayerTypes(white: .computer, black: .appUser)
            return Effect.send(.endo(.nextTurn))
        }
        
    case .playBothSides(let board):
        
        game.board = board ?? Chessboard.start()
        game.players = PlayerTypes(white: .appUser, black: .appUser)
    case .clear:
        game.board = Chessboard.start()
        game.players = PlayerTypes(white: .none, black: .none)
    }
    
    return Effect.empty()
}

*/
