//
//  SearchViewController.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import UIKit
import Utils

public final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: SearchViewModel
    private lazy var tableView = UITableView()
    
    private lazy var deleteSearchLogSubject = PassthroughSubject<String, Never>()
    
    private lazy var searchBar = WMSearchBar()
    
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
    }
    
    public override func bind() {
        let input = SearchViewModel.Input(
            updateSearchLog: searchBar.searchSubject.eraseToAnyPublisher(),
            deleteSearchLog: deleteSearchLogSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.adapter.apply(items: items)
            }
            .store(in: &cancellable)
        
        output.search
            .sink { _ in
                Logger.print("DA")
            } receiveValue: {
                print($0)
            }
            .store(in: &cancellable)
        
        searchBar.backButton
            .tapPublisher
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellable)
    }
}

extension SearchViewController: SearchLogTableViewAdapterDelegate {
    func didTapSearch(with keyword: String) {
        Logger.print(keyword)
    }
    
    func didTapDelete(with keyword: String) {
        Logger.print(keyword)
        deleteSearchLogSubject.send(keyword)
    }
}
