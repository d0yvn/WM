//
//  DIContainer.swift
//  WorksMobile
//
//  Created by USER on 2023/01/13.
//

import DataLayer
import DomainLayer
import PresentationLayer
import Foundation

import Swinject

final public class DIContainer {
    
    let container = Container()
    
    static let shared = DIContainer()
    
    func registerDependencies() {
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
}

// MARK: - RegisterReposities
private extension DIContainer {
    
    func registerRepositories() {
        container.register(SearchLogRepository.self) { _ in
            DefaultSearchLogRepository()
        }
        
        container.register(SearchNetworkRepository.self) { _ in
            DefaultSearchNetworkRepository()
        }
    }
}

// MARK: - RegisterUseCases
private extension DIContainer {
    
    func registerUseCases() {
        registerSearchLogUseCases()
    }
    
    func registerSearchLogUseCases() {
        guard let repository = container.resolve(SearchLogRepository.self) else {
            return
        }
        
        container.register(FetchSearchLogUseCase.self) { _ in
            DefaultFetchSearchLogUseCase(searchLogRepository: repository)
        }
        
        container.register(DeleteSearchLogUseCase.self) { _ in
            DefaultDeleteSearchLogUseCase(searchLogRepository: repository)
        }
        
        container.register(UpdateSearchLogUseCase.self) { _ in
            DefaultUpdateSearchLogUseCase(searchLogRepository: repository)
        }
    }
}

// MARK: - RegisterViewModels
private extension DIContainer {
    
    func registerViewModels() {
        container.register(MainViewModel.self) { _ in
            MainViewModel()
        }
    }
}

extension DIContainer: MainDependency {
  
    public func makeFetchSearchLogUseCase() -> FetchSearchLogUseCase? {
        return container.resolve(FetchSearchLogUseCase.self)
    }
    
    public func makeDeleteSearchLogUseCase() -> DeleteSearchLogUseCase? {
        return container.resolve(DeleteSearchLogUseCase.self)
    }
    
    public func makeUpdateSearchLogUseCase() -> UpdateSearchLogUseCase? {
        return container.resolve(UpdateSearchLogUseCase.self)
    }
}
