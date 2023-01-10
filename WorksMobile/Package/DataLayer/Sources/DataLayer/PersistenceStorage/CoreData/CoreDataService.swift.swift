//
//  CoreDataService.swift
//  
//
//  Created by USER on 2023/01/09.
//
import Combine
import CoreData
import DomainLayer
import Foundation
import Utils

final public class CoreDataService {
    
    public static let shared = CoreDataService()
    
    private let modelName = "WorksMobile"
    
    private init() { }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        guard
            let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
            let momd = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Error loading model from bundle")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: momd)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> Future<[T], CoreDataError> {
        return Future<[T], CoreDataError> { [weak self] promise in
            self?.performBackgroundTask { context in
                do {
                    let items = try context.fetch(request)
                    return promise(.success(items))
                } catch {
                    return promise(.failure(CoreDataError.fetchError(error.localizedDescription)))
                }
            }
        }
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> AnyPublisher<T, CoreDataError> {
        return self.fetch(request: request)
            .compactMap { $0.first }
            .eraseToAnyPublisher()
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>, offset: Int, display: Int, sortDescriptor: [NSSortDescriptor]) -> Future<[T], CoreDataError> {
        
        request.fetchOffset = offset
        request.fetchLimit = display
        request.sortDescriptors = sortDescriptor
        
        return self.fetch(request: request)
    }
    
    private func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

// MARK: - SearchLog

// TODO: - Generic한 메소드만 CoreDataService에 구현하고 디테일한 동작은 분리하도록 수정하기.
extension CoreDataService {
    
    func delete(keyword: String, request: NSFetchRequest<SearchLogEntity>) -> Future<[SearchLogEntity], CoreDataError> {
        return Future<[SearchLogEntity], CoreDataError> { [weak self] promise in
            self?.performBackgroundTask { context in
                do {
                    var items = try context.fetch(request)
                    self?.delete(key: keyword, entities: &items, in: context)
                    return promise(.success(items))
                } catch {
                    return promise(.failure(CoreDataError.deleteError(error.localizedDescription)))
                }
            }
        }
    }
    
    func save(keyword: String, request: NSFetchRequest<SearchLogEntity>) -> Future<String, CoreDataError> {
        return Future<String, CoreDataError> { [weak self] promise in
            guard let self else { return }
            
            self.performBackgroundTask { context in
                do {
                    if let storedEntity = try context.fetch(request).first {
                        storedEntity.latestDate = Date()
                    } else {
                        let entitiy = SearchLogEntity(keyword: keyword, context: context)
                        Logger.print(entitiy)
                    }
                    try context.save()
                    
                    return promise(.success(keyword))
                } catch {
                    return promise(.failure(CoreDataError.fetchError(error.localizedDescription)))
                }
            }
        }
    }
}

extension CoreDataService {
    
    private func cleanUp(keyword: String, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = SearchLogEntity.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SearchLogEntity.latestDate), ascending: false)]
        
        var result = try context.fetch(request)
        delete(key: keyword, entities: &result, in: context)
        removeSearchLog(entities: &result, in: context)
    }
    
    private func delete(key: String, entities: inout [SearchLogEntity], in context: NSManagedObjectContext) {
        entities
            .filter { $0.keyword == key }
            .forEach { context.delete($0) }
        entities.removeAll { $0.keyword == key }
    }
    
    private func removeSearchLog(limit: Int = 30, entities: inout [SearchLogEntity], in context: NSManagedObjectContext) {
        guard entities.count > limit else { return }
        
        Logger.print("stored keyword entitiy = \(entities.count)")
        
        entities.suffix(entities.count - limit)
            .forEach { context.delete($0) }
    }
}

// MARK: - Save search result
extension CoreDataService {
//    func saveMovieResult(movie: MovieDTO) -> Future<[Movie], CoreDataError> {
//        let request = MovieEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "link == %@", movie.link)
//
//        return self.fetch(request: request)
//            .flatMap { entities in
//
//                self?.performBackgroundTask { context in
//                    guard let entitiy = entities.first else {
//                        MovieEntity(movie: movie.toModel(), context: context)
//
//                        self.saveContext()
//                        return
//                    }
//                }
//
//            })
//            .eraseToAnyPublisher()
//            .flatMap { entities in
//                if entities.isEmpty {
//
//                }
//            }
//        return Future<[Movie], CoreDataError> { [weak self] promise in
//
//        }
//    }
}
