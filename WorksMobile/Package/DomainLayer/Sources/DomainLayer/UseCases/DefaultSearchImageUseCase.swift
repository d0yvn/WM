//
//  DefaultSearchImageUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public final class DefaultSearchImageUseCase {
    private let searchNetworkRepository: SearchNetworkRepository
    private let searchCacheReository: SearchCacheRepository
    
    public init(
        searchNetworkRepository: SearchNetworkRepository,
        searchCacheReository: SearchCacheRepository
    ) {
        self.searchNetworkRepository = searchNetworkRepository
        self.searchCacheReository = searchCacheReository
    }
}

extension DefaultSearchImageUseCase: SearchImageUseCase {
    
    public func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool
    ) -> AnyPublisher<[Image], Error> {
        return isConnected ? searchNetworkRepository.fetchSearchResult(keyword: keyword, start: offset, display: count) : searchCacheReository.fetchSearchResult(keyword: keyword, start: offset, display: count)
    }
}

