//
//  MovieDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct MovieDTO: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let putDate: String
    let director: String
    let actor: String
    let userRating: String
}
