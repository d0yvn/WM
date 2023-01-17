//
//  SearchResultViewController.swift
//  WorksMobile
//
//  Created by USER on 2023/01/06.
//

import Combine
import UIKit
import Utils

public final class SearchResultViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: SearchResultViewModel
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }()
    
    private lazy var collectionViewAdapter: SearchResultCollectionViewAdapter = {
        let adapter = SearchResultCollectionViewAdapter(collectionView: collectionView)
        adapter.delegate = self
        return adapter
    }()
    
    private lazy var placeholderView = PlaceHolderView(status: .notStart)
    
    private lazy var searchBarView = WMSearchView(type: .icon)
    
    private let webLinkSubject = PassthroughSubject<String, Never>()
    private let searchViewTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - LifeCycle
    public init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "통합"
    }
    
    public override func configureHierarchy() {
        self.view.addSubviews([
            searchBarView,
            placeholderView,
            collectionView
        ])
    }
    
    public override func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: offset * 6)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    public override func configureAttributes() {
        configureTapGesture()
        searchBarView.configure(.icon)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public override func bind() {
        
        let input = SearchResultViewModel.Input(
            tabStatus: collectionViewAdapter.tabStatus.eraseToAnyPublisher(),
            searchViewTrigger: searchViewTrigger.eraseToAnyPublisher(),
            showDetailView: webLinkSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.state
            .sink { [weak self] in
                self?.handleState($0)
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private
extension SearchResultViewController {
    private func handleState(_ state: SearchResultViewModel.State) {
        switch state {
        case .none(let dataSource):
            self.collectionViewAdapter.apply(dataSource)
            self.placeholderView.updateDescription(.notStart)
        case .fetching:
            self.placeholderView.isHidden = true
            self.showFullSizeIndicator()
        case .success(let dataSource):
            self.placeholderView.isHidden = true
            self.collectionViewAdapter.apply(dataSource)
            self.hideFullSizeIndicator()
        case .failure:
            self.placeholderView.updateDescription(.fail)
        }
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.searchBarView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        searchViewTrigger.send(Void())
    }
}

// MARK: - SearchResultCollectionViewAdapterDelegate
extension SearchResultViewController: SearchResultCollectionViewAdapterDelegate {
    func showDetailView(with link: String) {
        self.webLinkSubject.send(link)
    }
    
    func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
}
