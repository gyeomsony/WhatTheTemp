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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        //window.rootViewController = UINavigationController(rootViewController: WeatherViewController())
        
        let viewModel = SearchViewModel(repository: KakaoMapRepository()) // SearchViewModel의 인스턴스 생성
        window.rootViewController = UINavigationController(rootViewController: SearchViewController(viewModel: viewModel))

        window.makeKeyAndVisible()
        
        self.window = window
    }
}


