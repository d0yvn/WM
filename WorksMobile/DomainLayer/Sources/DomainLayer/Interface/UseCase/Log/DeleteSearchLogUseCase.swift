//
//  DeleteSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

public protocol DeleteSearchLogUseCase {
    func delete(keyword: String) -> AnyPublisher<[SearchLog], Error>
}
