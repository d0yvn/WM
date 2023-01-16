//
//  SearchResultSection.swift
//  
//
//  Created by USER on 2023/01/16.
//

import Foundation

public enum SearchResultSection: Int, CaseIterable {
    case tab = 0
    case movie
    case blog
    case image
    case webDocument
    
    public enum Item: Hashable {
        case tab(SearchTab)
        case movie(Movie)
        case blog(Blog)
        case image(Image)
        case webDocument(WebDocument)
    }
}
