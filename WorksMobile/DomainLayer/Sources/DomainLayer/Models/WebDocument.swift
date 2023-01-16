//
//  WebDocument.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct WebDocument: Hashable {
    
    public let title: String
    public let link: String
    public let description: String
    
    public init(
        title: String,
        link: String,
        description: String
    ) {
        self.title = title
        self.link = link
        self.description = description
    }
}
