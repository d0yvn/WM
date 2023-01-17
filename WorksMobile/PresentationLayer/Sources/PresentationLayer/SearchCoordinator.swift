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

final public class SearchCoordinator: Coordinator {
    
    public var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]
    
    public weak var dependency: SearchDependency?
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    public func start() {
        showMainViewController()
    }
    
    private func showMainViewController() {
        guard let viewModel = dependency?.makeMainViewModel() else { return }
        
        viewModel.coordinator = self
        
        let viewController = SearchResultViewController(viewModel: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController(_ subject: PassthroughSubject<SearchQuery, Never>) {
        
        guard
            let fetchSearchLogUseCase = dependency?.makeFetchSearchLogUseCase(),
            let deleteSearchLogUseCase = dependency?.makeDeleteSearchLogUseCase(),
            let updateSearchLogUseCase = dependency?.makeUpdateSearchLogUseCase()
        else {
            return
        }
        
        let viewModel = SearchViewModel(
            fetchSearchUseCase: fetchSearchLogUseCase,
            deleteSearchUseCase: deleteSearchLogUseCase,
            updateSearchUseCase: updateSearchLogUseCase,
            searchInput: subject
        )
        viewModel.coordinator = self
        
        let viewController = SearchViewController(viewModel: viewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetailViewController(_ link: String) {
        Logger.print(link)
    }
}
