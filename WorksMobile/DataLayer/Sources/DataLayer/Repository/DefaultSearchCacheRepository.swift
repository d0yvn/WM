//
//  DefaultSearchCacheRepository.swift
//
//
//  Created by USER on 2023/01/10.
//

import CoreData
import Combine
import DomainLayer
import Foundation

final public class DefaultSearchCacheRepository {
    private let searchResultStorage: DefaultSearchResultStorage

    public init(searchResultStorage: DefaultSearchResultStorage) {
        self.searchResultStorage = searchResultStorage
    }
}

extension DefaultSearchCacheRepository: SearchCacheRepository {
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error> {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        request.fetchOffset = start
        request.fetchLimit = display
        return searchResultStorage.fetch(request: request)
            .mapError { $0 as Error }
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }

    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Blog], Error> {
        let request = BlogEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        request.fetchOffset = start
        request.fetchLimit = display
        
        return searchResultStorage.fetch(request: request)
            .mapError { $0 as Error }
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }

    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Image], Error> {
        let request = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        request.fetchOffset = start
        request.fetchLimit = display
        
        return searchResultStorage.fetch(request: request)
            .mapError { $0 as Error }
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }

    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[WebDocument], Error> {
        let request = WebDocumentEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        request.fetchOffset = start
        request.fetchLimit = display
        
        return searchResultStorage.fetch(request: request)
            .mapError { $0 as Error }
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }
}
