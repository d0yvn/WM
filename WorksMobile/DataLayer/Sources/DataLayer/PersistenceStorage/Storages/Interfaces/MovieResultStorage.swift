//
//  MovieResultStorage.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import CoreData
import Foundation

public protocol SearchResultStorage {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> Future<[T], CoreDataError>
//    func update<T: NSManagedObject, E: Codable>(request: NSFetchRequest<T>, keyword: String, movies: [E]) -> Future<[T], CoreDataError>
}
