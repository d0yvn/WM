//
//  SearchImageUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation
import Utils

public protocol SearchImageUseCase {
    func execute(keyword: String, offset: Int, count: Int, isConnected: Bool) -> AnyPublisher<[Image], Error>
}

extension SearchImageUseCase {
    func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool = NetworkMonitorManager.shared.isConnected
    ) -> AnyPublisher<[Image], Error> {
        return execute(keyword: keyword, offset: offset, count: count, isConnected: isConnected)
    }
}
