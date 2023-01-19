//
//  DefaultSearchBlogUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation
import Utils

public final class DefaultSearchBlogUseCase {
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

extension DefaultSearchBlogUseCase: SearchBlogUseCase {
    public func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool
    ) -> AnyPublisher<[Blog], Error> {
        if isConnected {
            return NetworkMonitorManager.shared.isConnected ? searchNetworkRepository.fetchSearchResult(keyword: keyword, start: offset, display: count) : searchCacheReository.fetchSearchResult(keyword: keyword, start: offset, display: count)
        }
        return searchCacheReository.fetchSearchResult(keyword: keyword, start: offset, display: count)
    }
}
