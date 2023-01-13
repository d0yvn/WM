//
//  Coordinator.swift
//  
//
//  Created by USER on 2023/01/13.
//

import UIKit

public protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

public protocol Coordinator: AnyObject {
    
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var dependency: Dependency? { get }
    
    init(_ navigationController: UINavigationController)

    func start()
    func finish()
    func popViewController()
    func dismissViewController()
}

public extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
}
