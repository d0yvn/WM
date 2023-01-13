//
//  FetchSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

public protocol FetchSearchLogUseCase {
    func excute() -> AnyPublisher<[SearchLog], Error>
}
