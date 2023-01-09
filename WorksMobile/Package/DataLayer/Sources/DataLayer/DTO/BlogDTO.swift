//
//  BlogDTO.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public struct BlogDTO: Codable {
    let title: String
    let link: String
    let description: String
    let bloggerName: String
    let bloggerlink: String
    let postDate: String
}
