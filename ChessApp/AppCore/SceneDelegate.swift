//
//  SceneDelegate.swift
//  ChessApp
//
//  Created by David Crooks on 03/06/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var store:Store<AppState,AppAction>?
    var viewStore:ViewStore<AppState,AppAction>?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
       
        let enviroment = Enviroment()
        let appStore = Store(initialState: AppState(), reducer: appReducer, environment: enviroment)
        self.store = appStore
        self.viewStore = ViewStore(appStore)
        
        viewStore?.send(AppAction.chessGame(.subscribe))
        viewStore?.send(AppAction.checkerboard(.subscribe))
        viewStore?.send(AppAction.gameCenter(.subscribe))
        

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView:RootView(store:appStore))
            self.window = window
            enviroment.root = window.rootViewController
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        viewStore?.send(AppAction.chessGame(.saveCurrentGame))
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        viewStore?.send(AppAction.chessGame(.load))
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        viewStore?.send(AppAction.chessGame(.saveCurrentGame))
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        viewStore?.send(AppAction.chessGame(.load))
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        viewStore?.send(AppAction.chessGame(.saveCurrentGame))
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

