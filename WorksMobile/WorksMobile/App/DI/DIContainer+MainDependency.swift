//
//  DIContainer.swift
//  WorksMobile
//
//  Created by USER on 2023/01/14.
//

import DataLayer
import DomainLayer
import PresentationLayer
import Foundation

extension DIContainer: SearchDependency {
    
    public func makeMainViewModel() -> SearchResultViewModel? {
        return container.resolve(SearchResultViewModel.self)
    }
    
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
