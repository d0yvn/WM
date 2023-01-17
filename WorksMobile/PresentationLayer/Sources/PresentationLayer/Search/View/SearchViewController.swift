//
//  SearchViewController.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer
import UIKit
import Utils

public final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: SearchViewModel
    private lazy var tableView = UITableView()
    
    private lazy var deleteSearchLogSubject = PassthroughSubject<String, Never>()
    private lazy var willSearchText = PassthroughSubject<SearchQuery, Never>()
    
    private lazy var searchBar = WMSearchView(type: .back)
    
    lazy var adapter: SearchLogTableViewAdapter = {
        return SearchLogTableViewAdapter(tableView: self.tableView)
    }()
    
    // MARK: - LifeCycle
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func configureHierarchy() {
        self.view.addSubviews([
            searchBar,
            tableView
        ])
    }
    
    public override func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: offset * 6)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    public override func configureAttributes() {
        self.adapter.delegate = self
        searchBar.textField.becomeFirstResponder()
    }
    
    public override func bind() {
        searchBar.searchSubject
            .map { SearchQuery(keyword: $0, isHistory: true) }
            .sink { [weak self] query in
                self?.willSearchText.send(query)
            }
            .store(in: &cancellable)
        
        let input = SearchViewModel.Input(
            willUpdateSearchText: willSearchText.eraseToAnyPublisher(),
            willDeleteSearchText: deleteSearchLogSubject.eraseToAnyPublisher(),
            backButtonTap: searchBar.logoButton
                .tapPublisher.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.adapter.apply(items: items)
            }
            .store(in: &cancellable)
        
        output.typedText
            .sink { [weak self] text in
                guard let self else { return }
                self.searchBar.updateTextField(text)
            }
            .store(in: &cancellable)
    }
}

extension SearchViewController: SearchLogTableViewAdapterDelegate {
    func didTapDeleteAll() {
    }
    
    func didTapSearch(with keyword: String) {
        willSearchText.send(SearchQuery(keyword: keyword, isHistory: false))
    }
    
    func didTapDelete(with keyword: String) {
        deleteSearchLogSubject.send(keyword)
    }
}
