//
//  SceneDelegate.swift
//  WorksMobile
//
//  Created by USER on 2023/01/06.
//

import UIKit
import PresentationLayer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController)
        
        window?.rootViewController = navigationController
        
        appCoordinator?.start()
    }
}

