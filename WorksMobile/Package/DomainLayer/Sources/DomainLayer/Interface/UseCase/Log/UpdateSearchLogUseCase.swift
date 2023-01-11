//
//  UpdateSearchLogUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation

public protocol UpdateSearchLogUseCase {
    func update(keyword: String) -> AnyPublisher<String, Error>
}
