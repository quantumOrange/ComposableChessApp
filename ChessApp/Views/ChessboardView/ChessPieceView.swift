//
//  ChessPieceView.swift
//  Chess
//
//  Created by David Crooks on 01/06/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import SwiftUI
import CheckerboardView
import ChessEngine

extension ChessPiece:CheckerPiece {
    public var playerColor: CheckerboardView.PlayerColor {
        switch self.player {
        case .white:
            return.white
        case .black:
            return .black
        }
    }
}

public struct ChessPieceView : View
{

    let piece:ChessPiece
    
    
    public var body: some View
    {
        GeometryReader
        {   geometry in
            ZStack
            {
                
                Text(verbatim:"\(backgroundPiece)")
                    .font(.system(size: geometry.size.width, weight: .thin, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
                
                Text(verbatim:"\(piece.symbol)")
                    .font(.system(size: geometry.size.width, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
            }
        }
    }
    
    var backgroundPiece:String {
         //  guard let piece = store.value.piece else { return "" }
           return ChessPiece(player:.black, kind: piece.kind, id:piece.id).symbol
       }
}

/******************************************************/
/******************************************************/


let kinds = ChessPiece.Kind.allCases

let whitePieces =   kinds.map { ChessPiece(player: .white,  kind: $0 ,id:$0.rawValue)  }
let blackPieces =   kinds.map { ChessPiece(player: .black,  kind: $0 ,id:$0.rawValue)  }
let p = ChessPiece(player: .black,  kind: .king,id:1)


struct ChessPieceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ForEach(whitePieces){ piece in
                    ChessPieceView(piece: piece)
                }
            }
            VStack {
                ForEach(blackPieces){ piece in
                    ChessPieceView(piece: piece)
                }
            }
        }
        
        
    }
}
