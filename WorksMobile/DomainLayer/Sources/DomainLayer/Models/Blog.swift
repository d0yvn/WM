//
//  Blog.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct Blog: Hashable {
    let title: String
    let link: String
    let description: String
    let bloggerName: String
    let bloggerLink: String
    let postDate: String
    
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
