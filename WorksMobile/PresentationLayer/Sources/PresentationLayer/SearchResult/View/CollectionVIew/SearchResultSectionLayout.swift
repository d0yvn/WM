//
//  SearchResultSectionLayout.swift
//  
//
//  Created by USER on 2023/01/16.
//

import UIKit
import Utils

public enum SearchResultSectionLayout: Int, CaseIterable {
    
    case all = 0
    case movie
    case blog
    case image
    case webDocument
    
    var offset: CGFloat {
        return UIView().offset
    }
    
    func createLayout(section: Int, isCard: Bool) -> NSCollectionLayoutSection {
        if section == 0 {
            return generateTabLayout()
        } else {
            switch self {
            case .all, .blog, .image:
                return generateMovieLayout(isCard: isCard)
            case .webDocument:
                return generateWebDocumentLayout(isCard: isCard)
            case .movie:
                return generateMovieLayout(isCard: isCard)
            }
        }
    }
    
    private func generateTabLayout() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .estimated(offset * 7.5),
            height: .estimated(offset * 5.5),
            items: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let footerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .absolute(offset * 1), kind: ExpandFooterView.reuseIdentifier, alignment: .bottom)
        section.boundarySupplementaryItems = [footerView]
        return section
    }
    
    private func generateMovieLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let widthRatio = isCard ? 0.5 : 1.0
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(widthRatio),
            height: .estimated(offset * 15),
            items: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        let headerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .absolute(offset * 5), kind: SearchHeaderView.reuseIdentifier, alignment: .topLeading)
        let footerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .absolute(offset * 5), kind: ExpandFooterView.reuseIdentifier, alignment: .bottom)
        section.boundarySupplementaryItems = [headerView, footerView]
        return section
    }
    
    private func generateWebDocumentLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let widthRatio = isCard ? 0.5 : 1.0
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(widthRatio),
            height: .estimated(offset * 15),
            items: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: offset, bottom: offset, trailing: offset)
        section.interGroupSpacing = 10
        let headerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .absolute(offset * 5), kind: SearchHeaderView.reuseIdentifier, alignment: .topLeading)
        let footerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .estimated(offset * 5), kind: ExpandFooterView.reuseIdentifier, alignment: .bottom)
        section.boundarySupplementaryItems = [headerView, footerView]
        return section
    }
}
