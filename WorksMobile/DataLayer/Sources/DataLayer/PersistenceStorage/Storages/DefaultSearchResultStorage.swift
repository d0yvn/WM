//
//  DefaultSearchResultStorage.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import DomainLayer
import Foundation
import CoreData

final public class DefaultSearchResultStorage {
    private let coredataService: CoreDataService
    
    public init(coredataService: CoreDataService = .init()) {
        self.coredataService = coredataService
    }
}

extension DefaultSearchResultStorage: SearchResultStorage {
    
    public func fetch<T>(request: NSFetchRequest<T>) -> Future<[T], CoreDataError> where T: NSManagedObject {
        request.sortDescriptors = [.assendingByDate]
        
        return Future { promise in
            self.coredataService.performBackgroundTask { context in
                do {
                    let items = try context.fetch(request)
                    return promise(.success(items))
                } catch {
                    return promise(.failure(.fetchError(error.localizedDescription)))
                }
            }
        }
    }
    
//    public func update(request: NSFetchRequest<MovieEntity>, keyword: String, movies: [MovieDTO]) -> Future<[MovieEntity], CoreDataError> {
//        
//        return Future { promise in
//            self.coredataService.performBackgroundTask { context in
//                do {
//                    let items = try context.fetch(request)
// 
//                    let results: [MovieEntity] = movies.map { movie in
//                        self.findEntity(entities: items, movie: movie, context: context)
//                    }
//                    
//                    try context.save()
//                    return promise(.success(results))
//                } catch {
//                    return promise(.failure(.saveError(error.localizedDescription)))
//                }
//            }
//        }
//    }
//    
//    private func findEntity(entities: [MovieEntity], movie: MovieDTO, context: NSManagedObjectContext) -> MovieEntity {
//        if let index = entities.firstIndex(where: { entity in
//            guard let link = entity.link else { return false }
//            return link == movie.link
//        }) {
//            let alreayExistedEntity = entities[index]
//            alreayExistedEntity.latestDate = Date()
//            return alreayExistedEntity
//        } else {
//            return MovieEntity(movie: movie, context: context)
//        }
//    }
}
