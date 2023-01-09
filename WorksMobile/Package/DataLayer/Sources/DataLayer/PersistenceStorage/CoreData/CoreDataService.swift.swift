//
//  File.swift
//  
//
//  Created by USER on 2023/01/09.
//
import Combine
import CoreData
import Foundation

final public class CoreDataService {
    
    public static let shared = CoreDataService()
    
    private init() { }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorksMobile")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
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
    
    func saveSearchLog(keyword: String, request: NSFetchRequest<SearchLogEntity>) -> Future<String, CoreDataError> {
        return Future<String, CoreDataError> { [weak self] promise in
            self?.performBackgroundTask { context in
                do {
                    var items = try context.fetch(request)
                    self?.delete(key: keyword, entities: &items, in: context)
                    
                    _ = SearchLogEntity(keyword: keyword, context: context)
                    self?.removeSearchLog(entities: &items, in: context)
                    self?.saveContext()
                    return promise(.success(keyword))
                } catch {
                    return promise(.failure(CoreDataError.fetchError(error.localizedDescription)))
                }
            }
        }
    }
}

extension CoreDataService {
    
    private func delete(key: String, entities: inout [SearchLogEntity], in context: NSManagedObjectContext) {
        entities
            .filter { $0.keyword == key }
            .forEach { context.delete($0) }
        entities.removeAll { $0.keyword == key }
    }
    
    private func removeSearchLog(limit: Int = 30, entities: inout [SearchLogEntity], in context: NSManagedObjectContext) {
        guard entities.count > limit else { return }
        
        entities.suffix(entities.count - limit)
            .forEach { context.delete($0) }
    }
}
