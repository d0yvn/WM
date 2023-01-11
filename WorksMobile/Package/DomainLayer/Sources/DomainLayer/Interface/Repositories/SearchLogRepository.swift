//
//  SearchLogRepository.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public protocol SearchLogRepository {
    func fetch() -> AnyPublisher<[SearchLog], Error>
    func delete(keyword: String) -> AnyPublisher<[SearchLog], Error>
    func update(keyword: String) -> AnyPublisher<String, Error>
}
