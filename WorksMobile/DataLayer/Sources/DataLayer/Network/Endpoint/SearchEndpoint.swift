//
//  SearchEndpoint.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Alamofire
import Utils

public enum SearchEndpoint {
    case movie(keyword: String, start: Int, count: Int)
    case image(keyword: String, start: Int, count: Int)
    case webdocument(keyword: String, start: Int, count: Int)
    case blog(keyword: String, start: Int, count: Int)
}

extension SearchEndpoint: Endpoint {
    public var baseURL: String {
        return Secret.baseURL
    }
    
    public var path: String {
        switch self {
        case .blog:
            return "/blog.json"
        case .image:
            return "/image.json"
        case .webdocument:
            return "/webkr.json"
        case .movie:
            return "/movie.json"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .blog(keyword, start, count):
            return [
                "query": keyword,
                "display": count,
                "start": start
            ]
        case let .movie(keyword, start, count):
            return [
                "query": keyword,
                "display": count,
                "start": start
            ]
        case let .webdocument(keyword, start, count):
            return [
                "query": keyword,
                "display": count,
                "start": start
            ]
            
        case let .image(keyword, start, count):
            return [
                "query": keyword,
                "display": count,
                "start": start
            ]
        }
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}
