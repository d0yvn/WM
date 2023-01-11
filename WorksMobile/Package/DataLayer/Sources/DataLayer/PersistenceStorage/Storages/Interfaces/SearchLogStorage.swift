//
//  SearchLogStorage.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import Foundation

public protocol SearchLogStorage {
    func fetch() -> Future<[SearchLogEntity], CoreDataError>
    func delete(keyword: String) -> Future<[SearchLogEntity], CoreDataError>
    func update(keyword: String) -> Future<String, CoreDataError>
}
