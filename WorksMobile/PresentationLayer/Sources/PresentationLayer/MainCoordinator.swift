//
//  MainCoordinator.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer
import UIKit
import Utils

final public class MainCoordinator: Coordinator {
    
    public var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]
    
    public var dependency: Dependency?
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    public func start() {
        showMainViewController()
    }
    
    private func showMainViewController() {
        guard
            let dependency = dependency as? MainDependency,
            let viewModel = dependency.makeMainViewModel()
        else {
            return
        }
        
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController(subject: CurrentValueSubject<SearchQuery, Never>) {
        
        guard
            let dependency = dependency as? MainDependency,
            let fetchSearchLogUseCase = dependency.makeFetchSearchLogUseCase(),
            let deleteSearchLogUseCase = dependency.makeDeleteSearchLogUseCase(),
            let updateSearchLogUseCase = dependency.makeUpdateSearchLogUseCase()
        else {
            return
        }
        
        let viewModel = SearchViewModel(
            fetchSearchUseCase: fetchSearchLogUseCase,
            deleteSearchUseCase: deleteSearchLogUseCase,
            updateSearchUseCase: updateSearchLogUseCase,
            willSearchText: subject
        )
        viewModel.coordinator = self
        
        let viewController = SearchViewController(viewModel: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
}
