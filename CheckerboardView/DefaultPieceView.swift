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
    let width:CGFloat
    
    var systemName:String {
        switch piece.playerColor {
        case .white:
            return "ant.circle"
        case .black:
            return "ant.circle.fill"
        }
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: width))
            .frame(width: width, height: width, alignment: .center)
            
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
             DefaultPieceView(piece:DefaultPiece(playerColor: .black, id: 0), width:70)
             DefaultPieceView(piece:DefaultPiece(playerColor: .white, id: 1), width:70)
        }
        
    }
}
