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
public protocol CheckerboardEnviromentProtocol
{
    func subscribe() -> Effect<CheckerboardAction,Never>
    func playMove(move:Move) -> Effect<CheckerboardAction,Never> // should return a .clear
}

public struct CheckerBoardUIState:Equatable {
    var playerPointOfView:PlayerColor = .white
    var selectedSquare:CheckerboardSquare? = nil
    var validDestinationSquares:[CheckerboardSquare] = []
    
    //var playable:Playable = .playSide(.white)
    var userHasFlippedBoard:Bool = false //TODO get rid of this.
    
    public init() {}
}

public protocol CheckerboardGame:Equatable {
    associatedtype Piece:CheckerPiece
    var placedPieces:[ PlacedCheckerPiece<Piece>] { get }
    
    mutating func applyMove(move:Move) -> Bool // returns true if the move is valid and succesfully applied
    func validDestinationSquares(for selected:CheckerboardSquare) -> [CheckerboardSquare]
}

public struct CheckerboardState<Game:CheckerboardGame>:Equatable {
    public var game:Game
    
    var turn:PlayerColor
    let checkerColors:CheckerColors
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
    public var boardState:CheckerBoardUIState
    
    public init(game:Game,turn:PlayerColor, boardState:CheckerBoardUIState,checkerColors:CheckerColors = CheckerColors.defaultColors){
        //self.placedPieces = placedPieces
        self.game = game
        self.turn = turn
        self.boardState = boardState
        self.checkerColors = checkerColors
    }
}

public enum CheckerboardAction {
    case tap(CheckerboardSquare)
    case clear
    case flipBoard(PlayerColor)
    case subscribe
    //case setGame(Game)
    //case validDestinationSquares([CheckerboardSquare])
}

struct DefaultGame:CheckerboardGame {
    func validDestinationSquares(for selected: CheckerboardSquare) -> [CheckerboardSquare] {
        return []
    }
    
    mutating func applyMove(move: Move) -> Bool {
        return true
    }
    
    typealias Piece = DefaultPiece
    var placedPieces:[ PlacedCheckerPiece<DefaultPiece>] { [] }
}

let defaultCheckerBoardReducer = Reducer<CheckerboardState<DefaultGame>, CheckerboardAction, CheckerboardEnviromentProtocol> (checkerBoardReducer)

func checkerBoardReducer2<Game>(  ) -> Reducer<CheckerboardState<Game>, CheckerboardAction, CheckerboardEnviromentProtocol> {
    fatalError()
}

public func checkerBoardReducer<Game>( state:inout CheckerboardState<Game>, action:CheckerboardAction, environment:CheckerboardEnviromentProtocol) -> Effect<CheckerboardAction, Never> {

    func isYourPiece(state:CheckerboardState<Game>, square:CheckerboardSquare) ->Bool{
        guard let placedPiece = state.game.placedPieces.first(where:{ $0.square == square })  else { return false }
        return placedPiece.piece.playerColor == state.turn
    }
    
    func clear() {
        state.boardState.selectedSquare = nil
        state.boardState.validDestinationSquares = []
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
                   state.boardState.validDestinationSquares = state.game.validDestinationSquares(for:square)
                 // return environment.selected(square)
              }
              else if let selectedSquare = state.boardState.selectedSquare
              {
                  //We have a selected square already
                  let move =  Move(from: selectedSquare,to:square)
                
                  return environment.playMove(move: move)
                /*
                if state.game.applyMove(move: move) {
                    clear()
                    return environment.requestMove(state.game)
                }
                  */
                  /*
                  let effect = Effect<Output<ChessboardAction,ChessboardExoAction>>.sync(work: {
                      return .exo(.move(move))
                  })
                  
                  return effect
                  */
                
                //return environment.playMove(move)
              }
          }
      case .clear:
          clear()
      
      case .flipBoard:
          //state.userHasFlippedBoard.toggle()
          state.boardState.playerPointOfView =  !state.boardState.playerPointOfView
    //case .validDestinationSquares(let squares):
        //state.boardState.validDestinationSquares = squares
    case .subscribe:
        return environment.subscribe()
    }
    return .none

}
