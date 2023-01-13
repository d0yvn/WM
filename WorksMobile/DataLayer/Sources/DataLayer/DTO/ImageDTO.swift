//
//  ImageDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import DomainLayer
import Foundation

public struct ImageDTO: Codable {
    let title: String
    let link: String
    let thumbnail: String
    let sizeHeight: String
    let sizeWidth: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, thumbnail
        case sizeHeight = "sizeheight"
        case sizeWidth = "sizewidth"
    }
    
    public func toModel() -> Image {
        return Image(title: self.title, link: self.link, thumbnail: self.thumbnail)
    }
}
