//
//  SearchCacheRepository.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

public protocol SearchCacheRepository {
    func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error>
    func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Blog], Error>
    func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Image], Error>
    func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[WebDocument], Error>
}
