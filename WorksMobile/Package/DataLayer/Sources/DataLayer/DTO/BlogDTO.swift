//
//  BlogDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import DomainLayer
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
    
    public func toModel() -> Blog {
        return Blog(
            title: self.title,
            link: self.link,
            description: self.description,
            bloggerName: self.bloggerName,
            bloggerLink: self.bloggerLink,
            postDate: self.postDate
        )
    }
}
