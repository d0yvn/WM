//
//  SearchLogTableViewAdapter.swift
//  
//
//  Created by USER on 2023/01/11.
//

import DomainLayer
import UIKit
import Utils

protocol SearchLogTableViewAdapterDelegate: AnyObject {
    func didTapSearch(with keyword: String)
    func didTapDelete(with keyword: String)
    func didTapDeleteAll()
}

final class SearchLogTableViewAdapter: NSObject {

    typealias DataSource = UITableViewDiffableDataSource<Section, SearchLog>
    
    enum Section: CaseIterable {
        case main
    }
    
    private let rowHeight: CGFloat = 40
    private let headerHeight: CGFloat = 40
    
    private var dataSource: DataSource?
    private var tableView: UITableView
    
    weak var delegate: SearchLogTableViewAdapterDelegate?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        configureAttribute()
    }
    
    private func configureAttribute() {
        self.configureDataSource()
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = rowHeight
        tableView.register(SearchLogTableViewCell.self)
        tableView.register(SearchLogTableHeaderView.self)
    }
    
    func apply(items: [SearchLog]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, SearchLog>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(items, toSection: .main)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - TableViewDataSource
extension SearchLogTableViewAdapter {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(SearchLogTableViewCell.self, for: indexPath) else {
                return .init()
            }
            cell.configure(searchLog: item)
            cell.delegate = self
            return cell
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0, let headerView = tableView.dequeueHeaderFooterView(SearchLogTableHeaderView.self) else {
            return nil
        }
        headerView.delegate = self
        return headerView
    }
}

// MARK: - TableViewDelegate
extension SearchLogTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.didTapSearch(with: item.keyword)
    }
}

extension SearchLogTableViewAdapter: SearchLogTableViewCellDelegate {
    func didTapDeleteButton(keyword: String) {
        delegate?.didTapDelete(with: keyword)
    }
}

extension SearchLogTableViewAdapter: SearchLogTableHeaderViewDelegate {
    func didTapAllDelete() {
        delegate?.didTapDeleteAll()
    }
}
