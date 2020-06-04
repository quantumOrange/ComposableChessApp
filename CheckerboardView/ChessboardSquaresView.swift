//
//  ChessboardSquaresView.swift
//  Chess
//
//  Created by david crooks on 22/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//
//import DCArchitecture
import ComposableArchitecture
import SwiftUI
//import Chess

enum SquareColor {
    case dark
    case light
    
    static func at(rank:Int,file:Int) -> SquareColor {
        return (rank + file).isMultiple(of: 2) ?
                                            .dark :
                                            .light
    }
}

extension SquareColor {
    
    var color:Color {
        switch self {
        case .dark:
            return Color(hue: 240.0/360.0, saturation:0.25, brightness: 0.75)
        case .light:
            return Color.white
        }
    }
    
    var highlightedColor:Color {
        switch self {
        case .dark:
            return Color(hue: 60.0/360.0, saturation:0.75, brightness: 0.85)
        case .light:
            return Color(hue: 60.0/360.0, saturation:0.75, brightness: 0.85)
        }
    }
    
    var selectedColor:Color {
        switch self {
        case .dark:
            return Color(hue: 60.0/360.0, saturation:0.95, brightness: 0.65)
        case .light:
            return Color(hue: 60.0/360.0, saturation:0.5, brightness: 1.0)
        }
    }
    
}


struct CheckerboardSquaresState:Equatable {
    var possibleDestinationSquares:[CheckerboardSquare] = []
    var selectedSquare:CheckerboardSquare?
    var playerPointOfView:PlayerColor = .white
    func color(rank:Int,file:Int) -> Color {
        let sqColor = SquareColor.at(rank:rank, file: file)
      //  return sqColor.color
        let square = CheckerboardSquare(rank:rank, file:file)
        
       let couldMoveToSquare = possibleDestinationSquares.contains(square)
        if (selectedSquare == square){
            return sqColor.selectedColor
        }
        else if (couldMoveToSquare){
            return sqColor.highlightedColor
        }
        else {
            return sqColor.color
        }
       //let selected = selectedSquare == square
        
      // let highlighted = selected || couldMoveToSquare
        
      // return highlighted ? sqColor.highlightedColor : sqColor.color
    }
}

struct CheckerboardSquaresView: View {
    
    let store: Store<CheckerboardSquaresState,Never>
    
    let width:CGFloat
    
    var squareWidth:CGFloat {
        width/8.0
    }
    /*
    var possibleDestinationSquares:[ChessboardSquare] {
        guard let selected = store.value.selectedSquare else { return [] }
        //TODO: clean this up . Make validMove internal
        return validMoves(chessboard: store.value.chessGame.board,
                          square: selected,
                      includeCastles: true)
            .map { $0.to.chessboardSquare}
    }
    */
    
    
    var body: some View {
         WithViewStore(self.store) { viewStore in
            
        HStack(alignment: .center,spacing:0)
                       {
                      
                            //ForEach(files(orientatedFor:viewStore.playerPointOfView))
                        
                        ForEach(files(orientatedFor:viewStore.state.playerPointOfView))
                                { file in
                                    
                                    
                                    VStack(alignment: .center, spacing:0)
                                    {
                                        ForEach(ranks(orientatedFor:.white)) { rank in
                                            
                                        Spacer()
                                         .frame(width:self.squareWidth,height:self.squareWidth)
                                            .background(viewStore.state.color(rank: rank, file: file))
                                     }
                                    }
                                    
                                }
                            }.animation(.easeInOut(duration: 2.0))
                        
                       }
                        
    }
}


let nullReducer = Reducer<CheckerboardSquaresState,Never,Void>{ _ , _ , _ in .none }

let mockCheckerboardSquaresState = CheckerboardSquaresState(possibleDestinationSquares: [CheckerboardSquare(rank: 1, file: 2),
CheckerboardSquare(rank: 3, file: 5)], selectedSquare: CheckerboardSquare(rank: 2, file: 3), playerPointOfView: .white)

struct ChessboardSquaresView_Previews: PreviewProvider {
    static var previews: some View {
        CheckerboardSquaresView(store: Store(initialState: mockCheckerboardSquaresState, reducer: nullReducer, environment: ()), width: 300)
    }
}
