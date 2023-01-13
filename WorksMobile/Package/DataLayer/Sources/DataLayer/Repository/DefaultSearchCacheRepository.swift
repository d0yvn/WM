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

final class DefaultSearchCacheRepository {
    private let movieStorage: MovieResultStorage

    public init(movieStorage: MovieResultStorage) {
        self.movieStorage = movieStorage
    }
}

extension DefaultSearchCacheRepository: SearchCacheRepository {
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error> {
        
        return movieStorage.fetch(keyword: keyword)
            .mapError { $0 as Error }
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }
//
//    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Blog], Error> {
//        let request = BlogEntity.fetchRequest()
//        return coreDataService.fetch(request: request, offset: start, display: display)
//            .map { $0.map { $0.toModel() } }
//            .mapError { $0 as Error }
//            .eraseToAnyPublisher()
//    }
//
//    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Image], Error> {
//        let request = ImageEntity.fetchRequest()
//        return coreDataService.fetch(request: request, offset: start, display: display)
//            .map { $0.map { $0.toModel() } }
//            .mapError { $0 as Error }
//            .eraseToAnyPublisher()
//    }
//
//    func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[WebDocument], Error> {
//        let request = WebDocumentEntity.fetchRequest()
//        return coreDataService.fetch(request: request, offset: start, display: display)
//            .map { $0.map { $0.toModel() } }
//            .mapError { $0 as Error }
//            .eraseToAnyPublisher()
//    }
}
