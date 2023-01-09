//
//  ImageDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

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
}
