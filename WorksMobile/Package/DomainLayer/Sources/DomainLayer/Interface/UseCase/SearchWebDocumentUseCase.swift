//
//  SearchWebDocumentUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation
import Utils

public protocol SearchWebDocumentUseCase {
    func execute(keyword: String, offset: Int, count: Int, isConnected: Bool) -> AnyPublisher<[WebDocument], Error>
}

extension SearchWebDocumentUseCase {
    func execute(
        keyword: String,
        offset: Int,
        count: Int,
        isConnected: Bool = NetworkMonitorManager.shared.isConnected
    ) -> AnyPublisher<[WebDocument], Error> {
        return execute(keyword: keyword, offset: offset, count: count, isConnected: isConnected)
    }
}
