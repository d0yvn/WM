//
//  DefaultSearchMovieRepository.swift
//  
//
//  Created by USER on 2023/01/09.
//
import Combine
import DomainLayer
import Foundation

final public class DefaultSearchRepository {
    
    let networkService: NetworkService
    
    public init(networkService: NetworkService = DefaultNetworkService.shared) {
        self.networkService = networkService
    }
}

extension DefaultSearchRepository: SearchRepository {
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[DomainLayer.Blog], Error> {
        let endpoint = SearchEndpoint.blog(keyword: keyword, start: start, count: display)
        return networkService.request(with: endpoint, type: ResponseData<[BlogDTO]>.self)
            .map { response in
                response.items.map { $0.toModel() }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[DomainLayer.Image], Error> {
        let endpoint = SearchEndpoint.image(keyword: keyword, start: start, count: display)
        return networkService.request(with: endpoint, type: ResponseData<[ImageDTO]>.self)
            .map { response in
                response.items.map { $0.toModel() }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[DomainLayer.WebDocument], Error> {
        let endpoint = SearchEndpoint.movie(keyword: keyword, start: start, count: display)
        return networkService.request(with: endpoint, type: ResponseData<[WebDocumentDTO]>.self)
            .map { response in
                response.items.map { $0.toModel() }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    
    public func fetchSearchResult(keyword: String, start: Int, display: Int) -> AnyPublisher<[Movie], Error> {
        let endpoint = SearchEndpoint.movie(keyword: keyword, start: start, count: display)
        return networkService.request(with: endpoint, type: ResponseData<[MovieDTO]>.self)
            .map { response in
                response.items.map { $0.toModel() }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
