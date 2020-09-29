//
//  PlayerView.swift
//  Chess
//
//  Created by david crooks on 18/08/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import SwiftUI
import ChessEngine
import ComposableArchitecture

extension ChessPiece.Kind {

}

struct PlayerViewModel:Equatable {
    
    init(details: PlayerDetails, player:PlayerColor, type:PlayerType,isPlayersTurn:Bool, takenPieces:[ChessPiece] ){
        
        self.name = details.displayName
        self.image = details.image ?? UIImage()
        self.type = type
        self.isPlayersTurn = isPlayersTurn
        self.player = player
        
        takenPiecesString = takenPieces
                                .filter {   $0.player !=  player                                }
                                .map {      ChessPiece(player: .black, kind: $0.kind, id:0)     }
                                .sorted{    $0.value > $1.value                                 }
                                .map{       $0.symbol                                           }
                                .reduce(    "", +)
                       
        
    }
    
    var name:String
    var player:PlayerColor
    var type:PlayerType
    var isPlayersTurn:Bool
    
    var image:UIImage //= UIImage(named: <#T##String#>)
    
    
    
    var takenPiecesString:String
    
    var takenPieceColor:Color {
        switch player {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
    
}

func iconImageName(_ player:PlayerColor) -> String {
    switch player {
    case .white:
        return "person"
    case .black:
        return "person.fill"
    }
}

func statusImageName(_ player:PlayerType) -> String {
    switch player {
        
    case .none:
        return "person.crop.circle.fill.badge.xmark"
    case .appUser:
        return "person.crop.circle.fill"
    case .remote:
        return "antenna.radiowaves.left.and.right"
    case .computer:
        return "desktopcomputer"
    }
    
}

extension View {
    func debugOutline() -> some View {
        overlay(Rectangle().stroke(Color.yellow, lineWidth: 1))
    }
}

struct PlayerView : View
{
    let store: Store<PlayerViewModel,Never>
     
    var body: some View
    {
        WithViewStore(self.store)
        {   viewStore in
            ZStack
            {
                Rectangle()
                   .fill(AppColorScheme.insetBackgroundColor)
                
                HStack(alignment: .center)
                {
                    Image(uiImage: viewStore.state.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(Circle())
                        .shadow( radius: 15)
                        .overlay(Circle().stroke(AppColorScheme.outlineColor, lineWidth: 2))
                        
                        .padding()
                    //Spacer()
                    VStack(alignment: .leading)
                    {
                        HStack {
                            Text(viewStore.state.name)
                                //.font(Font.title)
                                .foregroundColor(AppColorScheme.textColor)
                            
                            switch viewStore.state.type {
                            case .remote:
                                Image(systemName:"antenna.radiowaves.left.and.right")
                                    .foregroundColor(AppColorScheme.textColor)
                            case .computer:
                                Image(systemName:"desktopcomputer")
                                    .foregroundColor(AppColorScheme.textColor)
                            default:
                                EmptyView()
                            }
                        }
                        
                        
                        Text(viewStore.takenPiecesString)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(viewStore.state.takenPieceColor)
                            //.padding(7)
                            
                    }
                    .layoutPriority(10)
                    
                    
                   Spacer()
                    
                   ZStack
                   {
                        
                    
                        if viewStore.state.isPlayersTurn
                        {
                            RoundedRectangle(cornerRadius:10)
                                .fill(AppColorScheme.insetInsetBackgroundColor)
                                .padding()
                            
                            switch viewStore.state.type
                            {
                            
                            case .appUser:
                                Text("Your turn")
                                    .font(Font.caption)
                                    .foregroundColor(AppColorScheme.textColor)

                            default:
                                Image(systemName:"clock")
                                    .foregroundColor(AppColorScheme.textColor)
                            }
                        }
                        
                    }
                  
                }
                
            }
           
        }
    }
}

#if DEBUG

let mockComputer = PlayerViewModel(details: PlayerDetails.defaultUser, player: .white, type: .appUser, isPlayersTurn: true, takenPieces: [])
let mockPlayer = PlayerViewModel(details: PlayerDetails.defaultUser, player: .white, type: .appUser, isPlayersTurn: true, takenPieces: [])
let mockRemote = PlayerViewModel(details: PlayerDetails.defaultUser, player: .white, type: .appUser, isPlayersTurn: true, takenPieces: [])


let mockPVReducer = Reducer<PlayerViewModel,Never,Void>{ _ , _, _ in  .none }

let mockPVStoreComputer = Store(initialState: mockComputer, reducer: mockPVReducer, environment: ())
let mockPVStorePlayer = Store(initialState: mockPlayer, reducer: mockPVReducer, environment: ())
let mockPVStoreRemote = Store(initialState: mockRemote, reducer: mockPVReducer, environment: ())
struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
 
        
        VStack(spacing:200) {
            PlayerView(store: mockPVStoreComputer)
                
            
            PlayerView(store: mockPVStoreRemote)
                
            
            PlayerView(store: mockPVStorePlayer)
               
        }
    }
}

#endif
