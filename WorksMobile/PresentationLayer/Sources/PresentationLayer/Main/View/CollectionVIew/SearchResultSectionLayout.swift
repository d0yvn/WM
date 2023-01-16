//
//  SearchResultSectionLayout.swift
//  
//
//  Created by USER on 2023/01/16.
//

import UIKit
import Utils

public enum SearchResultSectionLayout: Int, CaseIterable {
    
    case all
    case movie
    case blog
    case webDocument
    case image
    
    var offset: CGFloat {
        return UIView().offset
    }
    
    func createLayout(section: Int, isCard: Bool) -> NSCollectionLayoutSection {
        if section == 0 {
            return generateTabLayout()
        } else {
            return generateMovieLayout(isCard: isCard)
        }
    }
    
    private func generateTabLayout() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .estimated(50), height: .absolute(offset * 6))
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(1.0),
            height: .absolute(offset * 6),
            items: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: offset, trailing: 0)
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
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .estimated(offset * 5))
        
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(widthRatio),
            height: .fractionalHeight(1.0),
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
