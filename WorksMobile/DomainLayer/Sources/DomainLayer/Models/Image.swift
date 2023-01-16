//
//  Image.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct Image: Hashable {
    public let title: String
    public let link: String
    public let thumbnail: String
    
    public init(title: String, link: String, thumbnail: String) {
        self.title = title
        self.link = link
        self.thumbnail = thumbnail
    }
}
