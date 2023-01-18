//
//  Movie.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation
import Utils

public struct Movie: Hashable {
    @WithoutHTML public var title: String
    public let link: String
    public let image: String
    public let subtitle: String
    public let pubDate: String
    public let director: String
    public let actor: String
    public let userRating: String
    
    public init(
        title: String,
        link: String,
        image: String,
        subtitle: String,
        pubDate: String,
        director: String,
        actor: String,
        userRating: String
    ) {
        self.title = title
        self.link = link
        self.image = image
        self.subtitle = subtitle
        self.pubDate = pubDate
        self.director = director
        self.actor = actor
        self.userRating = userRating
    }
}
