//
//  MainDependency.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer

public protocol MainDependency: Dependency, AnyObject {
    func makeMainViewModel() -> MainViewModel?
    func makeFetchSearchLogUseCase() -> FetchSearchLogUseCase?
    func makeDeleteSearchLogUseCase() -> DeleteSearchLogUseCase?
    func makeUpdateSearchLogUseCase() -> UpdateSearchLogUseCase?
}
