//
//  DefaultSearchMovieUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public protocol SearchMovieUseCase {
    func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error>
}

public final class DefaultSearchMovieUseCase {
    
    let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
}

extension DefaultSearchMovieUseCase: SearchMovieUseCase {
    public func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error> {
        return repository.fetchSearchResult(keyword: keyword, start: start, display: display)
    }
}
