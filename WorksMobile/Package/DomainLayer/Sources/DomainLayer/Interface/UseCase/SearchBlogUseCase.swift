//
//  SearchBlogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation
import Utils

public protocol SearchBlogUseCase {
    func execute(keyword: String, offset: Int, count: Int, isConnected: Bool) -> AnyPublisher<[Blog], Error>
}

extension SearchBlogUseCase {
    func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool = NetworkMonitorManager.shared.isConnected
    ) -> AnyPublisher<[Blog], Error> {
        return execute(keyword: keyword, offset: offset, count: count, isConnected: isConnected)
    }
}
