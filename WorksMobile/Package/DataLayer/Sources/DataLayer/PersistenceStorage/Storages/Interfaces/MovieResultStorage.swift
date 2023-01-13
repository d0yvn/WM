//
//  MovieResultStorage.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import CoreData
import Foundation

public protocol MovieResultStorage {
    func fetch(keyword: String) -> Future<[MovieEntity], CoreDataError>
    func update(keyword: String, movies: [MovieDTO]) -> Future<[MovieEntity], CoreDataError>
}
