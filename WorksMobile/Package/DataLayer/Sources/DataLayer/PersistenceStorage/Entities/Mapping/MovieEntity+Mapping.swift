//
//  MovieEntity+Mapping.swift
//  
//
//  Created by USER on 2023/01/09.
//

import CoreData
import DomainLayer
import Foundation

extension MovieEntity {
    convenience init(movie: MovieDTO, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = movie.title
        self.subtitle = movie.subtitle
        self.link = movie.link
        self.image = movie.image
        self.userRating = movie.userRating
        self.pubDate = movie.pubDate
        self.director = movie.director
        self.actor = movie.actor
        self.latestDate = Date()
    }
}

extension MovieEntity {
    func toModel() -> Movie {
        return Movie(
            title: self.title ?? "",
            link: self.link ?? "",
            image: self.image ?? "",
            subtitle: self.subtitle ?? "",
            pubDate: self.pubDate ?? "",
            director: self.director ?? "",
            actor: self.actor ?? "",
            userRating: self.userRating ?? ""
        )
    }
}
