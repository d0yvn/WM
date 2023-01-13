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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        guard let mainViewModel = DIContainer.shared.container.resolve(MainViewModel.self) else {
            return
        }
        
        let viewController = MainViewController(viewModel: mainViewModel)
        viewController.dependency = DIContainer.shared
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
    }
}

