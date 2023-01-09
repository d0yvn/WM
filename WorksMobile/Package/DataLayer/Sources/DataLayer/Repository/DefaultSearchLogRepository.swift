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
    private let coreDataStorage: CoreDataService

    init(coreDataStorage: CoreDataService = CoreDataService.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension DefaultSearchLogRepository: SearchLogRepository {
    
    public func fetchSearchLog() -> AnyPublisher<[SearchLog], Error> {
        let request = SearchLogEntity.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(SearchLogEntity.latestDate), ascending: false)
        ]
        
        return coreDataStorage.fetch(request: request)
            .map { $0.map { $0.toModel() } }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func delete(keyword: String) -> AnyPublisher<[SearchLog], Error> {
        let request = SearchLogEntity.fetchRequest()
        return coreDataStorage.delete(keyword: keyword, request: request)
            .map { $0.map { $0.toModel() } }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func update(keyword: String) -> AnyPublisher<String, Error> {
        let request = SearchLogEntity.fetchRequest()
        
        return coreDataStorage.saveSearchLog(keyword: keyword, request: request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
