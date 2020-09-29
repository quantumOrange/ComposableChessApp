//
//  CheckerboardReducer.swift
//  CheckerboardView
//
//  Created by David Crooks on 19/05/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture


public protocol CheckerboardEnviromentProtocol
{
    func subscribe() -> Effect<CheckerboardAction,Never>
    func playMove(move:Move) -> Effect<CheckerboardAction,Never> // should return a .clear
}

public struct CheckerBoardUIState:Equatable {
    public var playerPointOfView:PlayerColor
    var defaultPlayerPointOfView:PlayerColor
    var selectedSquare:CheckerboardSquare? = nil
    var validDestinationSquares:[CheckerboardSquare] = []

    
    public init(defaultPOV:PlayerColor) {
        self.playerPointOfView = defaultPOV
        self.defaultPlayerPointOfView = defaultPOV
    }
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
    var userPlaysBlack:Bool
    var userPlaysWhite:Bool
    
    var isUsersTurn:Bool {
        switch turn {
        case .white:
            return userPlaysWhite
        case .black:
            return userPlaysBlack
        }
    }
    public var boardState:CheckerBoardUIState
    
    public init(game:Game,turn:PlayerColor, boardState:CheckerBoardUIState,userPlaysWhite:Bool, userPlaysBlack:Bool,checkerColors:CheckerColors = CheckerColors.defaultColors){
        self.game = game
        self.turn = turn
        self.boardState = boardState
        self.checkerColors = checkerColors
        self.userPlaysBlack = userPlaysBlack
        self.userPlaysWhite = userPlaysWhite
    }
}

public enum CheckerboardAction {
    case tap(CheckerboardSquare)
    case clear
    case reset
    case showFromPlayerPOV(PlayerColor?)
    case flipBoard
    case subscribe
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
                 
              }
              else if let selectedSquare = state.boardState.selectedSquare
              {
                  //We have a selected square already, so we are tapping the square to move TO
                  let move =  Move(from: selectedSquare,to:square)
                
                  return environment.playMove(move: move)
               
              }
          }
      case .clear:
          clear()
      
      case .flipBoard:
          state.boardState.playerPointOfView =  !state.boardState.playerPointOfView
      case .showFromPlayerPOV(let pov):
        if let pov = pov {
            state.boardState.playerPointOfView = pov
        }
        else {
            state.boardState.playerPointOfView = state.boardState.defaultPlayerPointOfView
        }
      case .subscribe:
            return environment.subscribe()
    
    case .reset:
        let defaultPOV:PlayerColor = (state.userPlaysBlack && !state.userPlaysWhite) ? .black : .white
        print("up black:\(state.userPlaysBlack) white\(state.userPlaysWhite)")
        print("\(defaultPOV)")
        state.boardState = CheckerBoardUIState(defaultPOV: defaultPOV)
        
    }
    return .none

}
