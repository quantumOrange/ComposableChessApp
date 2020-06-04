//
//  PlacedPieceView.swift
//  CheckerboardView
//
//  Created by David Crooks on 30/05/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

extension PlacedCheckerPiece {
    func offsetX(pointOfView:PlayerColor)->CGFloat {
        switch pointOfView {
        case .white:
            return CGFloat(square.file)
        case .black:
            return CGFloat(7 - square.file)
        }
        
    }
    
    func offsetY(pointOfView:PlayerColor)->CGFloat {
       switch pointOfView {
       case .white:
            return CGFloat(-square.rank)
       case .black:
            return CGFloat(square.rank - 7)
       }
      
    }
    
}

public struct PlacedPiecesState<Piece:CheckerPiece>:Equatable {
    var placedPieces:[PlacedCheckerPiece<Piece>]
    var pointOfView:PlayerColor
    
    public init(placedPieces:[PlacedCheckerPiece<Piece>],pointOfView:PlayerColor = .white){
        self.placedPieces = placedPieces
        self.pointOfView = pointOfView
    }
}

public protocol PieceViewRepresenable:CheckerPiece {
    associatedtype PieceView:View
   // init(piece:Piece,width:CGFloat)
    func view(size:CGFloat) -> PieceView
}

extension DefaultPiece:PieceViewRepresenable {
    
    func view(size:CGFloat) -> DefaultPieceView {
        DefaultPieceView(piece: self, width: size)
    }
}

struct PlacedPiecesView<Piece:PieceViewRepresenable>: View {
    let store: Store<PlacedPiecesState<Piece>,Never>
    
    let width:CGFloat
    
    var squareWidth:CGFloat { width/8.0 }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            VStack{
                     Spacer().frame(width: self.width/8.0, height:7*self.width/8.0, alignment: .center)
                     HStack(alignment: .bottom, spacing: 0) {
                        ZStack
                        {
                           ForEach(viewStore.placedPieces ){ placedPiece in
                            placedPiece.piece.view(size:self.squareWidth)
                            .offset(x: self.squareWidth * placedPiece.offsetX(pointOfView: viewStore.state.pointOfView) , y:  self.squareWidth * placedPiece.offsetY(pointOfView: viewStore.state.pointOfView))
                             .animation(.easeInOut(duration: 1.0))
                                    
                            }
                        }
                        Spacer().frame(width: 7*self.width/8.0, height: self.width/8.0, alignment: .center)
                    }
                   
                }
                
            }
            
        }
    
}


/* *********************************************************** */
/* *********************************************************** */
/* **********************   PREVIEW   ************************ */
/* *********************************************************** */
/* *********************************************************** */

let nullPieceReducer = Reducer<PlacedPiecesState<DefaultPiece>,Never,Void>{ _ , _ , _ in .none }


let pp1 = PlacedCheckerPiece(piece: DefaultPiece(playerColor: .white, id: 0), square: CheckerboardSquare(rank: 1, file: 3))
let pp2 = PlacedCheckerPiece(piece: DefaultPiece(playerColor: .white, id: 1), square: CheckerboardSquare(rank: 2, file: 1))
let pp3 = PlacedCheckerPiece(piece: DefaultPiece(playerColor: .black, id: 2), square: CheckerboardSquare(rank: 2, file: 2))
let pp4 = PlacedCheckerPiece(piece: DefaultPiece(playerColor: .black, id: 3), square: CheckerboardSquare(rank: 7, file: 6))

let mockPlacedPiecesState = PlacedPiecesState(placedPieces: [pp1,pp2,pp3,pp4], pointOfView: .white)

struct PlacedPieceView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        CheckerboardSquaresView(store: Store(initialState: CheckerboardSquaresState(), reducer: nullReducer, environment: ()), width: 300)
        PlacedPiecesView(store: Store(initialState: mockPlacedPiecesState, reducer: nullPieceReducer , environment: ()), width: 300)
        }
    }
}