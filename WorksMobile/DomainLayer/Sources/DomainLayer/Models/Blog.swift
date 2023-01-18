//
//  Blog.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation
import Utils

public struct Blog: Hashable {
    @WithoutHTML public var title: String
    public let link: String
    @WithoutHTML public var description: String
    public let bloggerName: String
    public let bloggerLink: String
    public let postDate: String
    
    public init(
        title: String,
        link: String,
        description: String,
        bloggerName: String,
        bloggerLink: String,
        postDate: String
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.bloggerName = bloggerName
        self.bloggerLink = bloggerLink
        self.postDate = postDate
    }
}
