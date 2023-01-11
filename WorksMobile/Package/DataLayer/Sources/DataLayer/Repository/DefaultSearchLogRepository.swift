//
//  DefaultSearchLogRepository.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import DomainLayer
import Foundation

public final class DefaultSearchLogRepository {
    private let storage: SearchLogStorage

    public init(storage: SearchLogStorage = DefaultSearchLogStorage()) {
        self.storage = storage
    }
}

extension DefaultSearchLogRepository: SearchLogRepository {
    
    public func fetch() -> AnyPublisher<[SearchLog], Error> {
        let request = SearchLogEntity.fetchRequest()
        request.sortDescriptors = [.assendingByDate]
        
        return storage.fetch()
            .map { $0.map { $0.toModel() } }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func delete(keyword: String) -> AnyPublisher<[SearchLog], Error> {
        return storage.delete(keyword: keyword)
            .map { $0.map { $0.toModel() } }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func update(keyword: String) -> AnyPublisher<String, Error> {
        let request = SearchLogEntity.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        
        return storage.update(keyword: keyword)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
