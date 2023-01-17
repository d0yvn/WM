//
//  Blog.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct Blog: Hashable {
    public let title: String
    public let link: String
    public let description: String
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
