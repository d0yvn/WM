//
//  BlogDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct BlogDTO: Codable {
    let title: String
    let link: String
    let description: String
    let bloggerName: String
    let bloggerLink: String
    let postDate: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, description
        case bloggerName = "bloggername"
        case bloggerLink = "bloggerlink"
        case postDate = "postdate"
    }
}
