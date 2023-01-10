//
//  DefaultUpdateSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

final public class DefaultUpdateSearchLogUseCase {
    
    private let searchLogRepository: SearchLogRepository
    
    public init(searchLogRepository: SearchLogRepository) {
        self.searchLogRepository = searchLogRepository
    }
}

extension DefaultUpdateSearchLogUseCase: UpdateSearchLogUseCase {
    public func update(keyword: String) -> AnyPublisher<String, Error> {
        return searchLogRepository.update(keyword: keyword)
    }
}
