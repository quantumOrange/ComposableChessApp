//
//  AppStore.swift
//  ChessApp
//
//  Created by David Crooks on 04/08/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ComposableArchitecture

let store = Store(initialState: AppState(), reducer: appReducer, environment: AppEnviroment())
