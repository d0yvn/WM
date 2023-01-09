//
//  DefaultSearchBlogUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public protocol SearchBlogUseCase {
    func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Blog], Error>
}

public final class DefaultSearchBlogUseCase {
    let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
}

extension DefaultSearchBlogUseCase: SearchBlogUseCase {
    public func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Blog], Error> {
        return repository.fetchSearchResult(keyword: keyword, start: start, display: display)
    }
}
