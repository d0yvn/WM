//
//  WebDocument.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct WebDocument {
    let title: String
    let link: String
    let description: String
    
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
