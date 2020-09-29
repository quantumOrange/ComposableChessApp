//
//  SettingsView.swift
//  ChessApp
//
//  Created by David Crooks on 28/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import SwiftUI
enum Level: Int, CaseIterable, Identifiable {
    case easy
    case two
    case three
    case four
    case five
    case six

    var id: Int { self.rawValue }
}

struct SettingsView: View {
    
    @State private var selectedLevel = Level.easy
    
    var body: some View {
        Picker("Chess Engine Level", selection: $selectedLevel) {
            ForEach(Level.allCases) { level in
                Text("Level \(level.rawValue)")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
