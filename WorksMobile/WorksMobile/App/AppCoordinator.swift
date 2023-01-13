//
//  AppCoordinator.swift
//  WorksMobile
//
//  Created by USER on 2023/01/13.
//

import Combine
import PresentationLayer
import UIKit

final class AppCoordinator: Coordinator {
    
    var dependency: Dependency?
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    // MARK: - Initializers
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        showMainFlow()
    }
}

// MARK: - connectFlow Methods
extension AppCoordinator {
    
    func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController)
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.dependency = DIContainer.shared
        mainCoordinator.start()
    }
}
