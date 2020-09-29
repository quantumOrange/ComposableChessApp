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

struct PlacedPiecesView<Piece:CheckerPiece,PieceView:View>: View {
    let store: Store<PlacedPiecesState<Piece>,Never>
    
    var body: some View
    {
        GeometryReader
        {   geometry in

            WithViewStore(self.store)
            {   viewStore in
                
                VStack
                {
                     Spacer().frame(width: geometry.size.width/8.0, height:7*geometry.size.width/8.0, alignment: .center)
                     HStack(alignment: .bottom, spacing: 0)
                     {
                        ZStack
                        {
                            ForEach(viewStore.placedPieces )
                            {   placedPiece in
                                configurePieceView(placedPiece: placedPiece, viewStore: viewStore, size: geometry.size.width/8.0)
                                    
                            }
                        }
                        Spacer().frame(width: 7*geometry.size.width/8.0, height: geometry.size.width/8.0, alignment: .center)
                    }
                       
                }
                
                    
            }
        }.aspectRatio(1, contentMode: .fit)
            
    }
    
    
    var getPieceView:(Piece) -> PieceView
    
    func configurePieceView(placedPiece:PlacedCheckerPiece<Piece>,viewStore: ViewStore<PlacedPiecesState<Piece>,Never>,  size:CGFloat) -> some View {
        getPieceView(placedPiece.piece)
            .offset(x: size * placedPiece.offsetX(pointOfView: viewStore.state.pointOfView) , y:  size * placedPiece.offsetY(pointOfView: viewStore.state.pointOfView))
            .animation(.easeInOut(duration: 1.0))
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
            CheckerboardSquaresView(store: Store(initialState: CheckerboardSquaresState(playerPointOfView: .white, checkerColors: CheckerColors.defaultColors), reducer: nullReducer, environment: ()))
            
            PlacedPiecesView(store: Store(initialState: mockPlacedPiecesState, reducer: nullPieceReducer , environment: ()), getPieceView:DefaultPieceView.init )
        }
    }
}
