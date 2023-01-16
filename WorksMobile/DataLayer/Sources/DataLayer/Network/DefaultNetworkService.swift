//
//  DefaultNetworkService.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Alamofire
import Combine
import Foundation

final public class DefaultNetworkService: NetworkService {
    
    public static let shared = DefaultNetworkService()
    
    private init () { }
    
    public func request<T: Decodable>(with endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, NetworkError> {
        return self.request(with: endpoint)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as? NetworkError ?? .parseError($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
    
    public func request(with endpoint: Endpoint) -> AnyPublisher<Data, NetworkError> {
        return AF.request(
            endpoint.baseURL + endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        .validate(statusCode: 200..<300)
        .publishData()
        .tryMap { result in
            guard let response = result.response else {
                throw NetworkError.invalidResponse
            }
            
            let verifiedResult = self.verify(
                data: result.data,
                urlResponse: response,
                error: result.error
            )
            
            switch verifiedResult {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        }
        .mapError { error -> NetworkError in
            return error as? NetworkError ?? .unknown
        }
        .eraseToAnyPublisher()
    }
}

private extension DefaultNetworkService {
    func verify(data: Data?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Data, NetworkError> {
        
        switch urlResponse.statusCode {
        case 200...299:
            if let data {
                return .success(data)
            } else {
                return .failure(NetworkError.unknown)
            }
        case 400...499:
            return .failure(NetworkError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(NetworkError.serverError(error?.localizedDescription))
        default:
            return .failure(NetworkError.unknown)
        }
    }
}
