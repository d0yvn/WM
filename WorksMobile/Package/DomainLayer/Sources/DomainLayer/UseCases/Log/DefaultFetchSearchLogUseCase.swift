//
//  DefaultFetchSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

public class DefaultFetchSearchLogUseCase {
    
    private let searchLogRepository: SearchLogRepository
    
    public init(searchLogRepository: SearchLogRepository) {
        self.searchLogRepository = searchLogRepository
    }
}

extension DefaultFetchSearchLogUseCase: FetchSearchLogUseCase {
    public func excute() -> AnyPublisher<[String], Error> {
        return searchLogRepository.fetch()
            .map { $0.map { $0.keyword } }
            .eraseToAnyPublisher()
    }
}
