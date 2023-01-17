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
        
        container.register(SearchCacheRepository.self) { _ in
            DefaultSearchCacheRepository(searchResultStorage: DefaultSearchResultStorage())
        }
    }
}

// MARK: - RegisterUseCases
private extension DIContainer {
    
    func registerUseCases() {
        reigsterSearchResultUseCases()
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
    
    func reigsterSearchResultUseCases() {
        
        guard
            let searchNetworkRepositroy = container.resolve(SearchNetworkRepository.self),
            let searchCacheRepository = container.resolve(SearchCacheRepository.self)
        else {
            return
        }
        
        container.register(SearchMovieUseCase.self) { _ in
            return DefaultSearchMovieUseCase(
                searchNetworkRepository: searchNetworkRepositroy,
                searchCacheReository: searchCacheRepository
            )
        }
        
        container.register(SearchImageUseCase.self) { _ in
            return DefaultSearchImageUseCase(
                searchNetworkRepository: searchNetworkRepositroy,
                searchCacheReository: searchCacheRepository)
        }
        
        container.register(SearchWebDocumentUseCase.self) { _ in
            return DefaultSearchWebDocumentUseCase(
                searchNetworkRepository: searchNetworkRepositroy,
                searchCacheReository: searchCacheRepository
            )
        }
        
        container.register(SearchBlogUseCase.self) { _ in
            return DefaultSearchBlogUseCase(
                searchNetworkRepository: searchNetworkRepositroy,
                searchCacheReository: searchCacheRepository
            )
        }
    }
}

// MARK: - RegisterViewModels
private extension DIContainer {
    
    func registerViewModels() {
        
        guard
            let searchMovieUseCase = container.resolve(SearchMovieUseCase.self),
            let searchImageUseCase = container.resolve(SearchImageUseCase.self),
            let searchBlogUseCase = container.resolve(SearchBlogUseCase.self),
            let searchWebDocumentUseCase = container.resolve(SearchWebDocumentUseCase.self)
        else {
            return
        }
        
        container.register(SearchResultViewModel.self) { _ in
            SearchResultViewModel(
                searchMovieUseCase: searchMovieUseCase,
                searchImageUseCase: searchImageUseCase,
                searchBlogUseCase: searchBlogUseCase,
                searchWebDocumentUseCase: searchWebDocumentUseCase
            )
        }
    }
}
