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

extension DIContainer: MainDependency {
    
    public func makeMainViewModel() -> MainViewModel? {
        return container.resolve(MainViewModel.self)
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
