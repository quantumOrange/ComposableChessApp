//
//  ExporeView.swift
//  ChessApp
//
//  Created by David Crooks on 28/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
import ChessEngine
import ComposableArchitecture
import CheckerboardView

struct ExploreState:Equatable {
    let exploredChessboard:Chessboard
    var checkerboardState:CheckerboardState<ChessGameState>
    
    init(exploredGame:ChessGameState) {
        self.checkerboardState =  CheckerboardState(game: exploredGame,
                          turn: exploredGame.board.whosTurnIsItAnyway.checkerboardColor ,
                          boardState:CheckerBoardUIState(defaultPOV: .white),
                          userPlaysWhite: true,
                          userPlaysBlack: true)
        
        self.exploredChessboard = exploredGame.board
    }
}

enum ExploreAction {
    case undo
    case redo
    case move
    case reset
    case checkerboard(CheckerboardAction)
}

struct ExploreView: View {
    let store: Store<ExploreState,ExploreAction>
    
    var body: some View {
        WithViewStore(self.store)
        {   viewStore in
            VStack(alignment:.center,spacing:0 )
            {
                ChessboardView(store:self.store.scope(state: \.checkerboardState, action: ExploreAction.checkerboard))
                    .layoutPriority(100)
                
                HStack {
                    Spacer()
                    IconButton(systemName:"chevron.left", store:self.store.stateless, actions: [.undo])
                        .foregroundColor(AppColorScheme.textColor)
                    Spacer()
                    IconButton(systemName:"chevron.right", store:self.store.stateless, actions: [.redo])
                        .foregroundColor(AppColorScheme.textColor)
                    Spacer()
                }
                .padding()
            }
        }
    }
}
/*
struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView(store: <#Store<ExploreState, ExploreAction>#>)
    }
}
*/
