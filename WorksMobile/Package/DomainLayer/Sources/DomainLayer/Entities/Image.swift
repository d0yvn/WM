//
//  Image.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct Image {
    let title: String
    let link: String
    let thumbnail: String
    
    public init(title: String, link: String, thumbnail: String) {
        self.title = title
        self.link = link
        self.thumbnail = thumbnail
    }
}
