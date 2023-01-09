//
//  ImageEntitiy+Mapping.swift
//  
//
//  Created by USER on 2023/01/09.
//

import CoreData
import DomainLayer
import Foundation

extension ImageEntity {
    convenience init(image: ImageDTO, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = image.title
        self.link = image.link
        self.thumbnail = image.thumbnail
        self.latestDate = Date()
    }
}

extension ImageEntity {
    func toModel() -> Image {
        return Image(
            title: self.title ?? "",
            link: self.link ?? "",
            thumbnail: self.thumbnail ?? ""
        )
    }
}
