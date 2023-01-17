//
//  SearchResultCollectionViewAdapter.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer
import Utils
import UIKit

protocol SearchResultCollectionViewAdapterDelegate: AnyObject {
    func updateNavigationTitle(with title: String)
    func showDetailView(with link: String)
}

final class SearchResultCollectionViewAdapter: NSObject {
    
    typealias Section = SearchResultSection
    typealias Item = SearchResultSection.Item
    
    var cancellable: Set<AnyCancellable> = []
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let collectionView: UICollectionView
    weak var delegate: SearchResultCollectionViewAdapterDelegate?
    
    private lazy var offset: CGFloat = {
        return collectionView.offset
    }()
    
    let searchTabType = CurrentValueSubject<SearchResultSectionLayout, Never>(.all)
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        configureCollectionView()
        configureDataSource()
        bind()
    }
    
    func apply(_ dataSources: [[Section: [Item]]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        dataSources.forEach { dataSource in
            dataSource.forEach { key, values in
                snapshot.appendSections([key])
                snapshot.appendItems(values.isEmpty ? [SearchResultSection.Item.emtpty] : values, toSection: key)
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Private Configure
extension SearchResultCollectionViewAdapter {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(BlogResultCell.self)
        collectionView.register(ImageResultCell.self)
        collectionView.register(MovieResultCell.self)
        collectionView.register(WebDocumentResultCell.self)
        collectionView.register(SearchTabViewCell.self)
        collectionView.register(EmptyCell.self)
        collectionView.registerReusableView(SearchHeaderView.self)
        collectionView.registerReusableView(ExpandFooterView.self)
        
        collectionView.setCollectionViewLayout(configureCollectionViewLayout(searchTabType.value, isCard: false), animated: true)
    }
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case let .movie(item):
                guard let cell = collectionView.dequeueCell(MovieResultCell.self, for: indexPath) else {
                    return .init()
                }
                cell.configure(with: item)
                return cell
            case let .blog(item):
                guard let cell = collectionView.dequeueCell(BlogResultCell.self, for: indexPath) else {
                    return .init()
                }
                cell.configure(with: item)
                return cell
            case let .image(item):
                guard let cell = collectionView.dequeueCell(ImageResultCell.self, for: indexPath) else {
                    return .init()
                }
                cell.configure(with: item)
                return cell
            case let .webDocument(item):
                guard let cell = collectionView.dequeueCell(WebDocumentResultCell.self, for: indexPath) else {
                    return .init()
                }
                cell.configure(with: item)
                return cell
            case let .tab(item):
                guard let cell = collectionView.dequeueCell(SearchTabViewCell.self, for: indexPath) else {
                    return .init()
                }
                cell.configure(with: item)
                return cell
            case .emtpty:
                guard let cell = collectionView.dequeueCell(EmptyCell.self, for: indexPath) else {
                    return .init()
                }
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard
                let self,
                let title = self.dataSource?.sectionIdentifier(for: indexPath.section)?.title else {
                return .init()
            }
//            guard
//                let self,
//                let item = self.dataSource?.itemIdentifier(for: indexPath),
//                let title = item.title
//            else {
//                return UICollectionReusableView()
//            }
            
            switch kind {
            case SearchHeaderView.reuseIdentifier:
                guard let headerView = collectionView.dequeResuableView(SearchHeaderView.self, for: indexPath) else {
                    return .init()
                }
                headerView.configure(with: title)
                return headerView
            case ExpandFooterView.reuseIdentifier:
                guard let footerView = collectionView.dequeResuableView(ExpandFooterView.self, for: indexPath) else {
                    return .init()
                }
                return footerView
            default:
                return .init()
            }
        }
    }
    
    func bind() {
    }
}

extension SearchResultCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        switch item {
        case let .tab(item):
            self.updateTabStatus(tab: item)
        case let .movie(item):
            self.delegate?.showDetailView(with: item.link)
        default:
            return
        }
    }
}

// MARK: - Layout
extension SearchResultCollectionViewAdapter {
    private func configureCollectionViewLayout(_ section: SearchResultSectionLayout, isCard: Bool) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            return section.createLayout(section: index, isCard: isCard)
        }
    }
}

extension SearchResultCollectionViewAdapter {
    private func updateTabStatus(tab: SearchTab) {
        self.delegate?.updateNavigationTitle(with: tab.title)
        
        guard let tabStatus = SearchResultSectionLayout(rawValue: tab.rawValue) else { return }
        searchTabType.send(tabStatus)
    }
}
