//
//  MovieDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import DomainLayer
import Foundation

public struct MovieDTO: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
    
    public func toModel() -> Movie {
        return Movie(
            title: self.title,
            link: self.link,
            image: self.image,
            subtitle: self.subtitle,
            pubDate: self.pubDate,
            director: self.director,
            actor: self.actor,
            userRating: self.userRating
        )
    }
}
