//
//  DefaultDeleteSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

final public class DefaultDeleteSearchLogUseCase {
    private let searchLogRepository: SearchLogRepository
    
    public init(searchLogRepository: SearchLogRepository) {
        self.searchLogRepository = searchLogRepository
    }
}

extension DefaultDeleteSearchLogUseCase: DeleteSearchLogUseCase {
    public func delete(keyword: String) -> AnyPublisher<[String], Error> {
        return searchLogRepository.delete(keyword: keyword)
            .map { $0.map { $0.keyword } }
            .eraseToAnyPublisher()
    }
}
