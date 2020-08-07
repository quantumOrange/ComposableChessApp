//
//  CheckerboardReducer.swift
//  CheckerboardView
//
//  Created by David Crooks on 19/05/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
//import Chess
import ComposableArchitecture

///     struct MyState { var count = 0, text = "" }
///     enum MyAction { case buttonTapped, textChanged(String) }
///     struct MyEnvironment { var analyticsClient: AnalyticsClient }
///
///     let myReducer = Reducer<MyState, MyAction, MyEnvironment> { state, action, environment in
///       switch action {
///       case .buttonTapped:
///         state.count += 1
///         return environment.analyticsClient.track("Button Tapped")
///
///       case .textChanged(let text):
///         state.text = text
///         return .none
///       }
///     }
///
public struct CheckerboardEnviroment {
    public init(playMove:@escaping (Move) -> Effect<CheckerboardAction,Never>,selected:@escaping (CheckerboardSquare) -> Effect<CheckerboardAction,Never> ){
        self.playMove = playMove
        self.selected = selected
    }
    var playMove:(Move) -> Effect<CheckerboardAction,Never> // should return a .clear
    var selected:(CheckerboardSquare) -> Effect<CheckerboardAction,Never>  // should return a .validDestinationSquares
}

public struct BoardState:Equatable {
    var playerPointOfView:PlayerColor = .white
    var selectedSquare:CheckerboardSquare? = nil
    var validDestinationSquares:[CheckerboardSquare] = []
    
    //var playable:Playable = .playSide(.white)
    var userHasFlippedBoard:Bool = false //TODO get rid of this.
    
    public init() {}
}

public struct CheckerboardState<Piece:PieceViewRepresenable>:Equatable {
    var placedPieces:[PlacedCheckerPiece<Piece>]
    var turn:PlayerColor
    
    var userPlaysBlack:Bool = false
    var userPlaysWhite:Bool = true
    
    var isUsersTurn:Bool {
        switch turn {
        case .white:
            return userPlaysWhite
        case .black:
            return userPlaysBlack
        }
    }
    public var boardState:BoardState
    
    public init(placedPieces:[PlacedCheckerPiece<Piece>],turn:PlayerColor, boardState:BoardState){
        self.placedPieces = placedPieces
        self.turn = turn
        self.boardState = boardState
    }
}

public enum CheckerboardAction {
    case tap(CheckerboardSquare)
    case clear
    case flipBoard(PlayerColor)
    case validDestinationSquares([CheckerboardSquare])
}

let defaultCheckerBoardReducer = Reducer<CheckerboardState<DefaultPiece>, CheckerboardAction, CheckerboardEnviroment> (checkerBoardReducer)


func checkerBoardReducer2<Piece>(  ) -> Reducer<CheckerboardState<Piece>, CheckerboardAction, CheckerboardEnviroment> {
    fatalError()
}


public func checkerBoardReducer<Piece>( state:inout CheckerboardState<Piece>, action:CheckerboardAction, environment:CheckerboardEnviroment) -> Effect<CheckerboardAction, Never> {

    func isYourPiece(state:CheckerboardState<Piece>, square:CheckerboardSquare) ->Bool{
        guard let placedPiece = state.placedPieces.first(where:{ $0.square == square })  else { return false }
        return placedPiece.piece.playerColor == state.turn
    }
    
    switch action {
      
      case .tap(let square):
        print("did Tap");
        if(!state.isUsersTurn) {
              //Can only select a square if it is the app users turn
              // ( for now anyway.  could allow pre-selection )
              break
          }
        if state.boardState.selectedSquare == square
          {
              //Tapping the selected square, so toggle off!
            state.boardState.selectedSquare = nil
            state.boardState.validDestinationSquares = []
          }
          else
          {
            
            if isYourPiece(state:state , square: square)
              {
                    //selecting a differant peice to move
                   state.boardState.selectedSquare = square
                   state.boardState.validDestinationSquares = []
                return environment.selected(square)
              }
              else if let selectedSquare = state.boardState.selectedSquare
              {
                  //We have a selected square already
                  let move =  Move(from: selectedSquare,to:square)
                
                  /*
                  let effect = Effect<Output<ChessboardAction,ChessboardExoAction>>.sync(work: {
                      return .exo(.move(move))
                  })
                  
                  return effect
                  */
                
                return environment.playMove(move)
              }
          }
      case .clear:
          /*
          switch state.chessboard.gamePlayState {
                                     
             case .won(let player):
                 state.gameOverAlertModel = GameOverAlertModel(state: .win(player), reason: .checkmate)
                 break
             case .draw:
                 state.gameOverAlertModel = GameOverAlertModel(state: .draw, reason: .agreement)
             case .inPlay:
                 break
          }
          */
        state.boardState.selectedSquare = nil
        state.boardState.validDestinationSquares = []
      
      case .flipBoard:
          //state.userHasFlippedBoard.toggle()
          state.boardState.playerPointOfView =  !state.boardState.playerPointOfView
    case .validDestinationSquares(let squares):
        state.boardState.validDestinationSquares = squares
    }
    return .none

}
