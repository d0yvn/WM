//
//  SearchTab.swift
//  
//
//  Created by USER on 2023/01/15.
//

import Foundation

public enum SearchTab: Int, CaseIterable, Hashable {
    case all = 0
    case image
    case blog
    case movie
    case webDocument

    public var title: String {
        switch self {
        case .all:
            return "통합"
        case .image:
            return "이미지"
        case .blog:
            return "블로그"
        case .movie:
            return "영화"
        case .webDocument:
            return "웹 문서"
        }
    }
    
    public var display: Int {
        switch self {
        case .all:
            return 3
        case .image:
            return 20
        case .blog, .movie, .webDocument:
            return 10
        }
    }
}
