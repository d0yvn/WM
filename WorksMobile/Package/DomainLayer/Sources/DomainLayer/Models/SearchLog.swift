//
//  SearchLog.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct SearchLog: Hashable {
    public let keyword: String
    public let latestDate: Date
    
    public init(
        keyword: String,
        latestDate: Date
    ) {
        self.keyword = keyword
        self.latestDate = latestDate
    }
}
