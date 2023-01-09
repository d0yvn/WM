//
//  WebDocumentDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import DomainLayer
import Foundation

public struct WebDocumentDTO: Codable {
    let title: String
    let link: String
    let description: String
    
    public func toModel() -> WebDocument {
        return WebDocument(title: self.title, link: self.link, description: self.description)
    }
}
