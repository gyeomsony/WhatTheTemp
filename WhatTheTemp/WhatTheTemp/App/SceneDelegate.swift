//
//  SceneDelegate.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let vm = WeatherViewModel(repository: WeatherRepository())
        let vc = WeatherViewController(viewModel: vm)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: LaunchViewController())
        window.makeKeyAndVisible()
        
        self.window = window
    }
}


