//
//  SearchResultViewModel.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import DomainLayer
import Foundation
import Utils

final public class SearchResultViewModel: ViewModelType {
    
    typealias DataSource = [SearchResultSection: [SearchResultSection.Item]]
    
    enum State {
        case none(_ dataSource: [DataSource])
        case fetching
        case success(_ dataSource: [DataSource])
        case paging(_ dataSource: DataSource)
        case failure
    }
    
    enum BrowserType {
        case inApp(_ link: String)
        case external(_ link: String)
    }
    
    // MARK: - UseCase
    private let searchMovieUseCase: SearchMovieUseCase
    private let searchImageUseCase: SearchImageUseCase
    private let searchBlogUseCase: SearchBlogUseCase
    private let searchWebDocumentUseCase: SearchWebDocumentUseCase
    
    // MARK: - Properties
    struct Input {
        let tabState: AnyPublisher<SearchTab, Never>
        let searchViewTrigger: AnyPublisher<Void, Never>
        let showDetailView: AnyPublisher<BrowserType, Never>
        let paginationTrigger: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let state: AnyPublisher<State, Never>
        let searchText: AnyPublisher<String, Never>
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    private var offset: Int = 1
    
    private let paginationDataSource = CurrentValueSubject<[DataSource], Never>([])
    private let searchInput = PassthroughSubject<SearchQuery, Never>()
    private lazy var stateSubject = CurrentValueSubject<State, Never>(.none(fetchTabItems()))
    
    weak var coordinator: SearchCoordinator?
    
    public init(
        searchMovieUseCase: SearchMovieUseCase,
        searchImageUseCase: SearchImageUseCase,
        searchBlogUseCase: SearchBlogUseCase,
        searchWebDocumentUseCase: SearchWebDocumentUseCase
    ) {
        self.searchMovieUseCase = searchMovieUseCase
        self.searchImageUseCase = searchImageUseCase
        self.searchBlogUseCase = searchBlogUseCase
        self.searchWebDocumentUseCase = searchWebDocumentUseCase
    }
    
    func transform(input: Input) -> Output {
        
        searchInput
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellable)
        
        input.searchViewTrigger
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.showSearchViewController(self.searchInput)
            }
            .store(in: &cancellable)
        
        input.showDetailView
            .sink { [weak self] type in
                switch type {
                case let .external(link):
                    self?.coordinator?.showExternalViewController(link)
                case let .inApp(link):
                    self?.coordinator?.showInAppViewController(link)
                }
            }
            .store(in: &cancellable)
        
        input.tabState
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .combineLatest(searchInput)
            .withUnretained(self)
            .flatMap { owner, parameters -> AnyPublisher<[DataSource], Error> in
                let (tab, query) = parameters
                owner.stateSubject.send(.fetching)
                owner.offset = 1
                return owner.fetchSearchResult(tab: tab, query: query)
            }
            .withUnretained(self)
            .map { owner, dataSource -> [DataSource] in
                owner.appendTabItems(dataSource)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.stateSubject.send(.failure)
                }
            }, receiveValue: { [weak self] dataSource in
                self?.stateSubject.send(.success(dataSource))
            })
            .store(in: &cancellable)
        
        let pagingParameter = searchInput.combineLatest(input.tabState)
        
        input.paginationTrigger
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .withLatestFrom(pagingParameter)
            .withUnretained(self)
            .flatMap { owner, paramters -> AnyPublisher<[DataSource], Error> in
                let (query, tab) = paramters
                owner.offset += tab.display
                return owner.fetchSearchResult(tab: tab, query: query, offset: owner.offset)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.stateSubject.send(.failure)
                }
            } receiveValue: { dataSource in
                guard let dataSource = dataSource.first else { return }
                self.stateSubject.send(.paging(dataSource))
            }
            .store(in: &cancellable)


        return Output(
            state: self.stateSubject.eraseToAnyPublisher(),
            searchText: self.searchInput.map(\.keyword).eraseToAnyPublisher()
        )
    }
}

// MARK: - Fetch & Mapping
extension SearchResultViewModel {
    
    private func fetchSearchResult(tab: SearchTab, query: SearchQuery, offset: Int = 1) -> AnyPublisher<[DataSource], Error> {
        switch tab {
        case .all:
            return self.fetchAllResult(query: query)
        case .image:
            return self.fetchImageResult(query: query, offset: offset)
        case .blog:
            return fetchBlogResult(query: query, offset: offset)
        case .movie:
            return self.fetchMovieResult(query: query, offset: offset)
        case .webDocument:
            return self.fetchWebDocumentResult(query: query, offset: offset)
        }
    }
    
    private func fetchTabItems() -> [DataSource] {
        let items = SearchTab.allCases.map { tab in
            SearchResultSection.Item.tab(tab)
        }
        return [[SearchResultSection.tab: items]]
    }
    
    private func appendTabItems(_ dataSources: [DataSource]) -> [DataSource] {
        return self.fetchTabItems() + dataSources
    }
    
    private func fetchMovieResult(query: SearchQuery, offset: Int, count: Int = 10) -> AnyPublisher<[DataSource], Error> {
        return self.searchMovieUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.movie($0)
                }
                return [[.movie: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchWebDocumentResult(query: SearchQuery, offset: Int, count: Int = 10) -> AnyPublisher<[DataSource], Error> {
        return searchWebDocumentUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.webDocument($0)
                }
                return [[.webDocument: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchBlogResult(query: SearchQuery, offset: Int, count: Int = 10) -> AnyPublisher<[DataSource], Error> {
        return searchBlogUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.blog($0)
                }
                return [[.blog: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchImageResult(query: SearchQuery, offset: Int, count: Int = 20) -> AnyPublisher<[DataSource], Error> {
        return searchImageUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.image($0)
                }
                return [[.image: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchAllResult(query: SearchQuery) -> AnyPublisher<[DataSource], Error> {
        return fetchWebDocumentResult(query: query, offset: 1, count: 3)
            .zip(
                fetchImageResult(query: query, offset: 1, count: 3),
                fetchMovieResult(query: query, offset: 1, count: 3),
                fetchBlogResult(query: query, offset: 1, count: 3)
            ) { webDocuments, images, movies, blogs in
                return images + blogs + movies + webDocuments
            }
            .eraseToAnyPublisher()
    }
}
