//
//  SearchLogEntitiy + Mapping.swift
//  
//
//  Created by USER on 2023/01/09.
//

import CoreData
import DomainLayer
import Foundation

extension SearchLogEntity {
    convenience init(keyword: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.keyword = keyword
        self.latestDate = Date()
    }
}

extension SearchLogEntity {
    func toModel() -> SearchLog {
        return SearchLog(keyword: self.keyword ?? "")
    }
}
