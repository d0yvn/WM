//
//  Endpoint.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Alamofire
import Foundation
import Utils

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    public var headers: HTTPHeaders? {
        return [
            "X-Naver-Client-Id": Secret.clientID,
            "X-Naver-Client-Secret": Secret.clientSecret
        ]
    }
    
    public var parameter: Parameters? { return nil }
}
