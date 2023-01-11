//
//  DefaultSearchWebDocumentUseCase.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Combine
import Foundation

public final class DefaultSearchWebDocumentUseCase {
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

extension DefaultSearchWebDocumentUseCase: SearchWebDocumentUseCase {
    public func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool
    ) -> AnyPublisher<[WebDocument], Error> {
        return isConnected ? searchNetworkRepository.fetchSearchResult(keyword: keyword, start: offset, display: count) : searchCacheReository.fetchSearchResult(keyword: keyword, start: offset, display: count)
    }
}
