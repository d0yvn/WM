//
//  SearchMovieUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation
import Utils

public protocol SearchMovieUseCase {
    func execute(keyword: String, offset: Int, count: Int, isConnected: Bool) -> AnyPublisher<[Movie], Error>
}

extension SearchMovieUseCase {
    func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool = NetworkMonitorManager.shared.isConnected
    ) -> AnyPublisher<[Movie], Error> {
        return execute(keyword: keyword, offset: offset, count: count, isConnected: isConnected)
    }
}
