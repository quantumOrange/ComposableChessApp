//
//  CheckerColors.swift
//  CheckerboardView
//
//  Created by David Crooks on 26/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import SwiftUI

public struct CheckerColors:Equatable {
    let darkSquares:Color
    let lightSquares:Color
    let highlightSquares:Color
    let selectedSquare:Color
    
    func at(rank:Int,file:Int) -> Color {
        (rank + file).isMultiple(of: 2) ?
                                            darkSquares :
                                            lightSquares
    }
    
    public init(dark:Color, highlight:Color, light:Color = Color.white) {
        self.darkSquares = dark
        self.lightSquares = light
        self.highlightSquares = highlight
        self.selectedSquare = highlight
    }
    
    public static let defaultColors = CheckerColors(     dark:Color(hue: 240.0/360.0, saturation:0.25, brightness: 0.75) ,
                                                    highlight: Color(hue: 60.0/360.0, saturation:0.75, brightness: 0.85))
}

