//
//  SearchMovieUseCase.swift
//  
//
//  Created by USER on 2023/01/10.
//

import Combine
import Foundation
import Utils

public protocol SearchMovieUseCase {
    func execute(keyword: String, offset: Int, count: Int, isConnected: Bool) -> AnyPublisher<[Movie], Error>
}
