//
//  NetworkError.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public enum NetworkError: Error {
    /// 옳지 않은 URL
    case invalidURL
    /// response가 옳지 않을 때
    case invalidResponse
    /// 400 ~ 499에러 발생
    case badRequest(String?)
    /// 500
    case serverError(String?)
    /// Json으로 parsing 에러
    case parseError(String?)
    /// 알 수 없는 에러.
    case unknown
    case invalidRequest
}
