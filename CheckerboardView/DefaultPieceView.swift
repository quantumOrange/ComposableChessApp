//
//  DefaultPieceView.swift
//  CheckerboardView
//
//  Created by David Crooks on 30/05/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import SwiftUI

struct DefaultPieceView: View {
    let piece:DefaultPiece
    
    var systemName:String {
        switch piece.playerColor {
        case .white:
            return "ant.circle"
        case .black:
            return "ant.circle.fill"
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            
            Image(systemName: systemName)
                .font(.system(size: geometry.size.width))
            
        }
            
    }
    
}

struct DefaultPieceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
             Button(action: {
                print("I was tapped")
             }) {
                Text("I'm a Button")
            }
             DefaultPieceView(piece:DefaultPiece(playerColor: .black, id: 0))
             DefaultPieceView(piece:DefaultPiece(playerColor: .white, id: 1))
        }
        
    }
}
