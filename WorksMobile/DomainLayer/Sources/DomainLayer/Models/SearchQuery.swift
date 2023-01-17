//
//  SearchQuery.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Foundation

public struct SearchQuery {
    public let keyword: String
    public let isNetworking: Bool
    
    public init(keyword: String, isHistory: Bool) {
        self.keyword = keyword
        self.isNetworking = isHistory
    }
}
