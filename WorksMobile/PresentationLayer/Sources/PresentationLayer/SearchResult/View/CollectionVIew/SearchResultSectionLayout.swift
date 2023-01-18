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
    case image
    case blog
    case movie
    case webDocument
    
    var offset: CGFloat {
        return UIView().offset
    }
    
    func createLayout(section: Int, isCard: Bool) -> NSCollectionLayoutSection {
        if section == 0 {
            return generateTabLayout()
        } else {
            switch self {
            case .all:
                return generateAllSearchLayout(section: section, isCard: isCard)
            case .image:
                return generateImageLayout(isCard: isCard)
            case .blog:
                return generateBlogLayout(isCard: isCard)
            case .webDocument:
                return generateWebDocumentLayout(isCard: isCard)
            case .movie:
                return generateMovieLayout(isCard: isCard)
            }
        }
    }
}

// MARK: - 검색 탭 Layout
extension SearchResultSectionLayout {
    private func generateTabLayout() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        let group = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .estimated(offset * 7.5),
            height: .estimated(offset * 5.5),
            items: [item]
        )
        
        let footerView = CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: .absolute(offset * 1), kind: ExpandFooterView.reuseIdentifier, alignment: .bottom)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [footerView]
        
        return section
    }
}

// MARK: - 통합 검색 Layout
extension SearchResultSectionLayout {
    private func generateAllSearchLayout(section: Int, isCard: Bool) -> NSCollectionLayoutSection {
        switch section {
        case 1:
            return generateAllImageLayout()
        case 2:
            return generateBlogLayout(isCard: isCard)
        case 3:
            return generateMovieLayout(isCard: isCard)
        default:
            return generateWebDocumentLayout(isCard: isCard)
        }
    }
}

// MARK: - MovieLayout
extension SearchResultSectionLayout {
    private func generateMovieLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let widthRatio = isCard ? 0.5 : 1.0
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(widthRatio),
            height: .estimated(offset * 16),
            items: [item]
        )
        
        let headerView = makeSearchHeaderView(height: .absolute(offset * 5))
        let footerView = makeExpandFooterView(height: .absolute(offset * 6))
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerView, footerView]
        
        return section
    }
}

// MARK: - ImageLayout
extension SearchResultSectionLayout {
    private func generateImageLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2)
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(1.0),
            height: .fractionalHeight(0.3),
            item: item,
            count: 2
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let headerView = makeSearchHeaderView(height: .absolute(offset * 5))
    
        section.boundarySupplementaryItems = [headerView]
        return section
    }
    
    private func generateAllImageLayout() -> NSCollectionLayoutSection {
        let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(2 / 3), height: .fractionalHeight(1.0))
        mainItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 4,
            trailing: 4
        )
        
        let pairItem = CompositionalLayout.createItem(
            width: .fractionalWidth(1.0),
            height: .fractionalHeight(2 / 3)
        )
        
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 4)
        
        let trailingGroup = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(1 / 3),
            height: .fractionalHeight(1.0),
            item: pairItem,
            count: 2
        )
        
        let mainWithPairGroup = CompositionalLayout.createGroup(
            alignment: .horizontal,
            width: .fractionalWidth(1.0),
            height: .fractionalWidth(2 / 3),
            items: [mainItem, trailingGroup])
        
        let headerView = makeSearchHeaderView(height: .absolute(offset * 5))
        let footerView = makeExpandFooterView(height: .absolute(offset * 6))
        
        let section = NSCollectionLayoutSection(group: mainWithPairGroup)
        section.boundarySupplementaryItems = [headerView, footerView]
        return section
    }
}

// MARK: - BlogLayout
extension SearchResultSectionLayout {
    private func generateBlogLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let widthRatio = isCard ? 0.5 : 1.0
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(widthRatio),
            height: .estimated(offset * 17),
            items: [item]
        )
        
        let headerView = makeSearchHeaderView(height: .absolute(offset * 5))
        let footerView = makeExpandFooterView(height: .absolute(offset * 6))
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerView, footerView]
        
        return section
    }
}

extension SearchResultSectionLayout {
    private func generateWebDocumentLayout(isCard: Bool) -> NSCollectionLayoutSection {
        let widthRatio = isCard ? 0.5 : 1.0
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        
        let group = CompositionalLayout.createGroup(
            alignment: .vertical,
            width: .fractionalWidth(widthRatio),
            height: .estimated(offset * 15),
            items: [item]
        )
        
        let headerView = makeSearchHeaderView(height: .absolute(offset * 5))
        let footerView = makeExpandFooterView(height: .absolute(offset * 6))
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = offset
        section.boundarySupplementaryItems = [headerView, footerView]
        
        return section
    }
}

// MARK: - Private Reuse
extension SearchResultSectionLayout {
    private func makeSearchHeaderView(height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        return CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: height, kind: SearchHeaderView.reuseIdentifier, alignment: .topLeading)
    }
    
    private func makeExpandFooterView(height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        return CompositionalLayout.createBoundarySupplementaryItem(width: .fractionalWidth(1.0), height: height, kind: ExpandFooterView.reuseIdentifier, alignment: .bottom)
    }
}
