//
//  WebDocument.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation
import Utils

public struct WebDocument: Hashable {

    @WithoutHTML public var title: String
    public let link: String
    @WithoutHTML public var description: String
    
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
