//
//  NetworkService.swift
//  
//
//  Created by USER on 2023/01/09.
//
import Combine
import Foundation

public protocol NetworkService {
    func request<T: Decodable>(with endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, NetworkError>
    func request(with endpoint: Endpoint) -> AnyPublisher<Data, NetworkError>
}
