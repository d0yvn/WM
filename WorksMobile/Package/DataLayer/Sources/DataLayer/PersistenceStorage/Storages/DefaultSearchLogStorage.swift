//
//  DefaultSearchLogStorage.swift
//  
//
//  Created by USER on 2023/01/11.
//

import CoreData
import Combine
import Foundation

final public class DefaultSearchLogStorage {
    
    private let coreDataService: CoreDataService
    
    public init(coreDataService: CoreDataService = .init()) {
        self.coreDataService = coreDataService
    }
}

extension DefaultSearchLogStorage: SearchLogStorage {
    
    public func fetch() -> Future<[SearchLogEntity], CoreDataError> {
        let request = SearchLogEntity.fetchRequest()
        request.sortDescriptors = [.assendingByDate]
        
        return Future<[SearchLogEntity], CoreDataError> { [weak self] promise in
            self?.coreDataService.performBackgroundTask { context in
                do {
                    let items = try context.fetch(request)
                    
                    return promise(.success(items))
                } catch {
                    return promise(.failure(.fetchError(error.localizedDescription)))
                }
            }
        }
    }
    
    public func delete(keyword: String) -> Future<[SearchLogEntity], CoreDataError> {
        let request = SearchLogEntity.fetchRequest()
        
        return Future<[SearchLogEntity], CoreDataError> { [weak self] promise in
            self?.coreDataService.performBackgroundTask { context in
                do {
                    var items = try context.fetch(request)
                    self?.delete(key: keyword, entities: &items, in: context)
                    return promise(.success(items))
                } catch {
                    return promise(.failure(.deleteError(error.localizedDescription)))
                }
            }
        }
    }
    
    public func update(keyword: String) -> Future<String, CoreDataError> {
        let request = SearchLogEntity.fetchRequest()
        
        return Future<String, CoreDataError> { [weak self] promise in
            guard let self else { return }
            
            self.coreDataService.performBackgroundTask { context in
                do {
                    let result = self.coreDataService.fetchFirst(request: request, context: context)
                    
                    switch result {
                    case .success(let item):
                        item.latestDate = Date()
                    case .failure:
                        _ = SearchLogEntity(keyword: keyword, context: context)
                    }
                    
                    try self.coreDataService.cache(request: request, in: context)
                    try context.save()
                    return promise(.success(keyword))
                } catch {
                    return promise(.failure(CoreDataError.fetchError(error.localizedDescription)))
                }
            }
        }
    }
}

private extension DefaultSearchLogStorage {
    
    private func cleanUp(keyword: String, context: NSManagedObjectContext) throws {
        
        let request: NSFetchRequest = SearchLogEntity.fetchRequest()
        request.sortDescriptors = [.assendingByDate]
        
        var result = try context.fetch(request)
        delete(key: keyword, entities: &result, in: context)
//        removeSearchLog(entities: &result, in: context)
    }
    
    private func delete(key: String, entities: inout [SearchLogEntity], in context: NSManagedObjectContext) {
        entities
            .filter { $0.keyword == key }
            .forEach { context.delete($0) }
        entities.removeAll { $0.keyword == key }
    }
}
