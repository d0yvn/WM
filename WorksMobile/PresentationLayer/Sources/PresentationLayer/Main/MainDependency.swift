//
//  MainDependency.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer

public protocol MainDependency: Dependency, AnyObject {
    func makeFetchSearchLogUseCase() -> FetchSearchLogUseCase?
    func makeDeleteSearchLogUseCase() -> DeleteSearchLogUseCase?
    func makeUpdateSearchLogUseCase() -> UpdateSearchLogUseCase?
}
