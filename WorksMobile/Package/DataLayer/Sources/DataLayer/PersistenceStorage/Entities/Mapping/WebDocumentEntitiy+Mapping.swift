//
//  WebDocumentEntitiy+Mapping.swift
//  
//
//  Created by USER on 2023/01/09.
//

import CoreData
import DomainLayer
import Foundation

extension WebDocumentEntity {
    convenience init(webDocument: WebDocumentDTO, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = webDocument.title
        self.link = webDocument.link
        self.desc = webDocument.description
        self.latestDate = Date()
    }
}

extension WebDocumentEntity {
    func toModel() -> WebDocument {
        return WebDocument(
            title: self.title ?? "",
            link: self.link ?? "",
            description: self.desc ?? ""
        )
    }
}
