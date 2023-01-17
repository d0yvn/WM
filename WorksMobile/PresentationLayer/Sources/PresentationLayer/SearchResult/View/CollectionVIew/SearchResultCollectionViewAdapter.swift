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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let collectionView: UICollectionView
    
    weak var delegate: SearchResultCollectionViewAdapterDelegate?
    
    var cancellable: Set<AnyCancellable> = []
    
    private lazy var offset: CGFloat = {
        return collectionView.offset
    }()
    
    let tabStatus = CurrentValueSubject<SearchTab, Never>(.all)
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        configureCollectionView()
        configureDataSource()
    }
    
    func apply(_ dataSources: [[Section: [Item]]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        dataSources.forEach { dataSource in
            dataSource.forEach { key, values in
                snapshot.appendSections([key])
                snapshot.appendItems(values.isEmpty ? [SearchResultSection.Item.emtpty] : values, toSection: key)
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: false, completion: { [weak self] in
            self?.updateLayout()
        })
    }
    
    func scrollEnabled(_ isEnabled: Bool) {
        collectionView.isScrollEnabled = isEnabled
    }
}

// MARK: - Private Configure
extension SearchResultCollectionViewAdapter {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(BlogResultCell.self)
        collectionView.register(ImageResultCell.self)
        collectionView.register(MovieResultCell.self)
        collectionView.register(WebDocumentResultCell.self)
        collectionView.register(SearchTabViewCell.self)
        collectionView.register(EmptyCell.self)
        collectionView.registerReusableView(SearchHeaderView.self)
        collectionView.registerReusableView(ExpandFooterView.self)
        
        collectionView.setCollectionViewLayout(configureCollectionViewLayout(.all, isCard: false), animated: true)
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
            guard let self else { return nil }
            
            switch kind {
            case SearchHeaderView.reuseIdentifier:
                guard
                    let headerView = collectionView.dequeResuableView(SearchHeaderView.self, for: indexPath),
                    let title = self.dataSource?.sectionIdentifier(for: indexPath.section)?.title
                else {
                    return .init()
                }
                headerView.configure(with: title)
                return headerView
            case ExpandFooterView.reuseIdentifier:
                guard let footerView = collectionView.dequeResuableView(ExpandFooterView.self, for: indexPath) else {
                    return .init()
                }
                
                guard let section = self.dataSource?.sectionIdentifier(for: indexPath.section), section.title != nil else {
                    return footerView
                }
                
                if self.tabStatus.value == .all {
                    footerView.configureButton(section)
                    footerView.delegate = self
                } else {
                    footerView.backgroundColor = .white
                }
                
                return footerView
            default:
                return .init()
            }
        }
    }
}

// MARK: - CollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension SearchResultCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case let .tab(item):
            self.updateTabStatus(tab: item)
        case let .movie(item):
            self.delegate?.showDetailView(with: item.link)
        case let .blog(item):
            self.delegate?.showDetailView(with: item.link)
        case let .image(item):
            self.delegate?.showDetailView(with: item.link)
        case let .webDocument(item):
            self.delegate?.showDetailView(with: item.link)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = self.tabStatus.value.rawValue
        let selectedIndexPath = IndexPath(item: item, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
}

// MARK: - CollectionViewLayout
extension SearchResultCollectionViewAdapter {
    private func updateLayout() {
        let index = tabStatus.value.rawValue
        
        guard let sectionLayout = SearchResultSectionLayout(rawValue: index) else {
            return
        }
        
        let layout = self.configureCollectionViewLayout(sectionLayout, isCard: false)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.setContentOffset(.zero, animated: true)
    }
    
    private func configureCollectionViewLayout(_ section: SearchResultSectionLayout, isCard: Bool) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            return section.createLayout(section: index, isCard: isCard)
        }
    }
}

// MARK: - Tap Update
extension SearchResultCollectionViewAdapter {
    private func updateTabStatus(tab: SearchTab) {
        delegate?.updateNavigationTitle(with: tab.title)
        tabStatus.send(tab)
    }
}

// MARK: - ExpandFooterViewDelegate
extension SearchResultCollectionViewAdapter: ExpandFooterViewDelegate {
    func didTapMoreButton(section: SearchResultSection?) {
        guard let rawValue = section?.rawValue, let tab = SearchTab(rawValue: rawValue) else { return }
        
        tabStatus.send(tab)
        let selectedIndexPath = IndexPath(item: rawValue, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
}
