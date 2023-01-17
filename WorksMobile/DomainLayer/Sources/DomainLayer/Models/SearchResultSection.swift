//
//  SearchResultSection.swift
//  
//
//  Created by USER on 2023/01/16.
//

import Foundation

public enum SearchResultSection: Int, CaseIterable {
    case tab = 0
    case image
    case blog
    case movie
    case webDocument
    
    public var title: String? {
        switch self {
        case .movie:
            return "영화"
        case .webDocument:
            return "웹 문서"
        case .blog:
            return "블로그"
        case .image:
            return "이미지"
        default:
            return nil
        }
    }
    
    public enum Item: Hashable {
        case tab(SearchTab)
        case movie(Movie)
        case blog(Blog)
        case image(Image)
        case webDocument(WebDocument)
        case emtpty
    }
}
