//
//  MainViewController.swift
//  WorksMobile
//
//  Created by USER on 2023/01/06.
//

import Combine
import UIKit
import Utils

public final class MainViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: MainViewModel
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }()
    
    private lazy var collectionViewAdapter: SearchResultCollectionViewAdapter = {
        let adapter = SearchResultCollectionViewAdapter(collectionView: collectionView)
        adapter.delegate = self
        return adapter
    }()
    
    private lazy var searchBarView = WMSearchView(type: .icon)
    
    private let webLinkSubject = PassthroughSubject<String, Never>()
    private let searchViewTrigger = PassthroughSubject<Void, Never>()
    // MARK: - LifeCycle
    public init(viewModel: MainViewModel) {
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
    }
    
    public override func configureAttributes() {
        configureTapGesture()
        searchBarView.configure(.icon)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public override func bind() {
        
        let input = MainViewModel.Input(
            searchViewTrigger: searchViewTrigger.eraseToAnyPublisher(),
            showDetailView: webLinkSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataSource in
                self?.collectionViewAdapter.apply(dataSource)
            }
            .store(in: &cancellable)
    }
    
    func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.searchBarView.addGestureRecognizer(tap)
    }
    
    @objc func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        searchViewTrigger.send(Void())
    }
}

extension MainViewController: SearchResultCollectionViewAdapterDelegate {
    func showDetailView(with link: String) {
        self.webLinkSubject.send(link)
    }
    
    func updateNavigationTitle(with title: String) {
        self.navigationItem.title = title
    }
}
