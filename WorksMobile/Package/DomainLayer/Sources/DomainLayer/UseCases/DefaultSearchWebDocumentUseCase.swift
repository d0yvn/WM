//
//  DefaultSearchWebDocumentUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public protocol SearchWebDocumentUseCase {
    func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[WebDocument], Error>
}

public final class DefaultSearchWebDocumentUseCase {
    let repository: SearchRepository
    
    public init(repository: SearchRepository) {
        self.repository = repository
    }
}

extension DefaultSearchWebDocumentUseCase: SearchWebDocumentUseCase {
    public func execute(keyword: String, start: Int, display: Int) -> AnyPublisher<[WebDocument], Error> {
        return repository.fetchSearchResult(keyword: keyword, start: start, display: display)
    }
}
