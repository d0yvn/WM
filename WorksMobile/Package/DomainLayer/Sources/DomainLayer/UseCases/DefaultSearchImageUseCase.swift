//
//  DefaultSearchImageUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public protocol SearchImageUseCase {
    func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Image], Error>
}

public final class DefaultSearchImageUseCase {
    let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
}

extension DefaultSearchImageUseCase: SearchImageUseCase {
    public func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Image], Error> {
        return repository.fetchSearchResult(keyword: keyword, start: start, display: display)
    }
}
