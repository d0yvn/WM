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

public enum CoreDataStorageType {
    case persistent, inMemory
}

final public class CoreDataService {
    
    private let storageType: CoreDataStorageType
    
    private let modelName = "WorksMobile"
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        guard
            let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
            let momd = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Error loading model from bundle")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: momd)
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Init
    public init(_ storageType: CoreDataStorageType = .persistent) {
        self.storageType = storageType
    }
    
    // MARK: - Fetch
    func fetch<T: NSManagedObject>(
        request: NSFetchRequest<T>,
        context: NSManagedObjectContext
    ) -> Result<[T], CoreDataError> {
        do {
            let items = try context.fetch(request)
            return .success(items)
        } catch {
            return .failure(.fetchError(error.localizedDescription))
        }
    }
    
    func fetch<T: NSManagedObject>(
        request: NSFetchRequest<T>,
        offset: Int,
        display: Int,
        sortDescriptor: [NSSortDescriptor] = [.assendingByDate],
        context: NSManagedObjectContext
    ) -> Result<[T], CoreDataError> {
        
        request.fetchOffset = offset
        request.fetchLimit = display
        request.sortDescriptors = sortDescriptor

        do {
            let items = try context.fetch(request)
            
            return .success(items)
        } catch {
            return .failure(.fetchError(error.localizedDescription))
        }
    }
    
    func fetchFirst<T: NSManagedObject>(
        request: NSFetchRequest<T>,
        context: NSManagedObjectContext
    ) -> Result<T, CoreDataError> {
        let result = self.fetch(request: request, context: context)
        
        switch result {
        case .success(let items):
            guard let firstItem = items.first else {
                return .failure(.fetchError("Not Existed Item"))
            }
            return .success(firstItem)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func cache<T: NSManagedObject>(limit: Int = 30, request: NSFetchRequest<T>, in context: NSManagedObjectContext) throws {
        do {
            request.sortDescriptors = [.assendingByDate]
            let items = try context.fetch(request)
            
            let overCapacity = items.count - limit
            guard overCapacity >= 0 else { return }
            
            Logger.print("entitiy count over: \(overCapacity)")
            
            items.suffix(overCapacity)
                .forEach { context.delete($0) }
        } catch {
            throw CoreDataError.fetchError("Invalid Request")
        }
    }
    
    func save<T: NSManagedObject>(request: NSFetchRequest<T>, context: NSManagedObjectContext) throws {
        
        if context.hasChanges {
            do {
                try self.cache(request: request, in: context)
                try context.save()
            } catch {
                throw CoreDataError.saveError(error.localizedDescription)
            }
        }
    }
    
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>, context: NSManagedObjectContext) throws {
        
        do {
            let items = try context.fetch(request)
            
            items.forEach {
                context.delete($0)
            }
            
            try context.save()
        } catch {
            throw CoreDataError.deleteError(error.localizedDescription)
        }
    }
    
    func saveContext(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.saveError("cannot save")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
