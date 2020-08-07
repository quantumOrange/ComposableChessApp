//
//  CheckerTypes.swift
//  CheckerboardView
//
//  Created by David Crooks on 22/05/2020.
//  Copyright © 2020 david crooks. All rights reserved.
//

import Foundation

public enum PlayerColor {
    case white, black
}

prefix func !(v:PlayerColor)-> PlayerColor {
    switch v {
    case .white:
        return .black
    case .black:
        return .white
    }
}

public struct Move:Equatable {
    let from:CheckerboardSquare
    let to:CheckerboardSquare
}

public struct CheckerboardSquare:Equatable {
    let rank:Int
    let file:Int
    
    public init(rank:Int,file:Int ){
        self.rank = rank
        self.file = file
    }
}

enum Playable:Equatable {
    case playSide(PlayerColor)
    case both
    case none
    
    func canPlay(as player:PlayerColor) -> Bool {
        switch self {
        case .playSide( let playableColor):
            return playableColor == player
        case .both:
            return true
        case .none:
            return false
        }
    }
}

public struct PlacedCheckerPiece<A:CheckerPiece>:Equatable,Identifiable {
    let piece:A
    public var id: A.ID { piece.id }
    let square:CheckerboardSquare
    //let player:PlayerColor
    
    public init(piece:A,square:CheckerboardSquare){
        self.piece = piece
        self.square = square
    }
}

public protocol CheckerPiece:Equatable,Identifiable {
    var playerColor:PlayerColor { get }
}

struct DefaultPiece:CheckerPiece {
    var playerColor: PlayerColor
    
    var id: Int
}

func files(orientatedFor pointOfView:PlayerColor) -> [Int] {
    switch pointOfView {
    case .white:
        return Array(0...7)
       // return  ChessFile.allCases
    case .black:
        return Array(0...7).reversed()
       // return  ChessFile.allCases.reversed()
    }
}

func ranks(orientatedFor pointOfView:PlayerColor) -> [Int] {
     switch pointOfView {
     case .white:
        return Array(0...7).reversed()
        // return  ChessRank.allCases.reversed()
     case .black:
        return Array(0...7)
        // return  ChessRank.allCases
     }
}

extension Int:Identifiable {
    public var id: Int {
        self
    }
}
