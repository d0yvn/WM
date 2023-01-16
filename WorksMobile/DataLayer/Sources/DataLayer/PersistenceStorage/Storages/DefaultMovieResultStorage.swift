//
//  DefaultMovieResultStorage.swift
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
    
//    public func update<T: NSManagedObject, E: Codable>(request: NSFetchRequest<T>, keyword: String, movies: [E]) -> Future<[T], CoreDataError> {
//        
//        let request = MovieEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "keyword == %@", keyword)
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
//    private func findEntity<T: NSManagedObject, E: Codable>(entities: [T], movie: E, context: NSManagedObjectContext) -> MovieEntity {
//        
//        if let index = entities.firstIndex(where: { $0.link ?? "" == movie.link }) {
//            let alreayExistedEntity = entities[index]
//            alreayExistedEntity.latestDate = Date()
//            return alreayExistedEntity
//        } else {
//            return  MovieEntity(movie: movie, context: context)
//        }
//    }
}
