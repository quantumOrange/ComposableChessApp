//
//  ChessboardSquare.swift
//  Chess
//
//  Created by david crooks on 15/09/2019.
//  Copyright © 2019 david crooks. All rights reserved.
//

import Foundation

extension Int8 {
    var rank:Int8 {
        self % 8
    }
    
    var file:Int8 {
       self / 8
    }
    
    public var chessboardSquare:ChessboardSquare {
        ChessboardSquare(rank: ChessRank.init(rawValue: self.rank)!, file: ChessFile.init(rawValue: self.file)!)
    }
    
    
    func getNeighbour(_ direction:Direction) -> Int8?
    {
           
           var rawRank = rank
           var rawFile = file
           
           switch direction {
           
           case .top:
               rawRank += 1
           case .bottom:
               rawRank -= 1
           case .left:
               rawFile -= 1
           case .right:
               rawFile += 1
           case .topLeft:
               rawFile -= 1
               rawRank += 1
           case .topRight:
               rawFile += 1
               rawRank += 1
           case .bottomLeft:
               rawFile -= 1
               rawRank -= 1
           case .bottomRight:
               rawFile += 1
               rawRank -= 1
           }
        
        if rawRank >= 0 && rawRank <= 7 &&  rawFile >= 0 && rawFile <= 7 {
             // sq = 8 * file + rank
            return 8 * rawFile + rawRank
        }
        
        return nil
    }
}




public struct ChessboardSquare:Equatable,Hashable,Codable {
    public let rank:ChessRank
    public let file:ChessFile
    
    public init(rank:ChessRank, file: ChessFile){
        self.rank = rank
        self.file = file
    }
}

extension ChessboardSquare {
    var int8Value:Int8 {
        Int8(self.file.rawValue*8 + self.rank.rawValue)
    }
}

extension ChessboardSquare {
    // ChessboardSquare(rank: newRank, file: newFile)
    init?(code:String){
        //let invalidRawValue = -1
        guard   let rank = ChessRank(code:String(code.suffix(1))),
                let file = ChessFile(code:String(code.prefix(1)))     else { return nil }
        
        self.rank = rank
        self.file = file
    }
}

enum Direction:CaseIterable {
    case top,bottom,left,right
    case bottomLeft,bottomRight,topLeft,topRight
}

extension ChessboardSquare {
    
    // Directions viewed from whites perspective
    
    
    func getNeighbour(_ direction:Direction) -> ChessboardSquare? {
        
        var rawRank = rank.rawValue
        var rawFile = file.rawValue
        
        switch direction {
        
        case .top:
            rawRank += 1
        case .bottom:
            rawRank -= 1
        case .left:
            rawFile -= 1
        case .right:
            rawFile += 1
        case .topLeft:
            rawFile -= 1
            rawRank += 1
        case .topRight:
            rawFile += 1
            rawRank += 1
        case .bottomLeft:
            rawFile -= 1
            rawRank -= 1
        case .bottomRight:
            rawFile += 1
            rawRank -= 1
        }
        
        if let newRank = ChessRank(rawValue: rawRank),
            let newFile = ChessFile(rawValue: rawFile) {
             return ChessboardSquare(rank: newRank, file: newFile)
        }
        
        return nil
    }
}

extension Chessboard {
   
    func squares(with piece:ChessPiece) -> [ChessboardSquare] {
        squares.filter{
            guard let otherPiece = self[$0]  else { return false }
            return ( otherPiece.kind == piece.kind && otherPiece.player == piece.player )
        }
    }
    
    public var positionPieces: [(ChessboardSquare,ChessPiece)] {
        return squares.compactMap {
            guard let piece = self[$0] else { return nil }
            return ($0,piece)
        }
    }
    
    
}


extension ChessboardSquare:CustomStringConvertible {
    public var description: String {
        "\(file)\(rank)"
    }
}

extension ChessboardSquare:Identifiable {
    public var id: Int {
        (self.file.id * 8 + self.rank.id)
    }
}

