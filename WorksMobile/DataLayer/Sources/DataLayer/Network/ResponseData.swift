//
//  NetworkResponse.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct ResponseData<T: Codable>: Codable {
    public let lastBuildDate: String
    public let total: Int
    public let start: Int
    public let display: Int
    public let items: T
}
