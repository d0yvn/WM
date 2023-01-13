//
//  BlogEntity+Mapping.swift
//  
//
//  Created by USER on 2023/01/09.
//

import CoreData
import DomainLayer
import Foundation

extension BlogEntity {
    convenience init(blog: BlogDTO, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = blog.title
        self.link = blog.link
        self.desc = description
        self.postDate = blog.postDate
        self.bloggerName = blog.bloggerName
        self.bloggerLink = blog.bloggerLink
        self.latestDate = Date()
    }
}

extension BlogEntity {
    func toModel() -> Blog {
        return Blog(
            title: self.title ?? "",
            link: self.link ?? "",
            description: self.desc ?? "",
            bloggerName: self.bloggerName ?? "",
            bloggerLink: self.bloggerLink ?? "",
            postDate: self.postDate ?? "")
    }
}
