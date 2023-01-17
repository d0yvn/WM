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
        case none
        case fetching
        case success(_ dataSource: [DataSource])
        case failure
    }
    
    // MARK: - UseCase
    private let searchMovieUseCase: SearchMovieUseCase
    private let searchImageUseCase: SearchImageUseCase
    private let searchBlogUseCase: SearchBlogUseCase
    private let searchWebDocumentUseCase: SearchWebDocumentUseCase
    
    // MARK: - Properties
    struct Input {
        let tabStatus: AnyPublisher<SearchTab, Never>
        let searchViewTrigger: AnyPublisher<Void, Never>
        let showDetailView: AnyPublisher<String, Never>
    }
    
    struct Output {
        let state: AnyPublisher<State, Never>
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    private var offset: Int = 1
    
    private let searchInput = PassthroughSubject<SearchQuery, Never>()
    private var stateSubject = CurrentValueSubject<State, Never>(.none)
    
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
        
        input.searchViewTrigger
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.showSearchViewController(self.searchInput)
            }
            .store(in: &cancellable)
        
        input.showDetailView
            .sink { [weak self] link in
                self?.coordinator?.showDetailViewController(link)
            }
            .store(in: &cancellable)
        
        searchInput
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellable)
        
        input.tabStatus
            .combineLatest(searchInput)
            .withUnretained(self)
            .flatMap { owner, parameters in
                let (tap, query) = parameters
                owner.stateSubject.send(.fetching)
                return owner.fetchSearchResult(tab: tap, query: query)
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
            
        
        return Output(state: self.stateSubject.eraseToAnyPublisher())
    }
    
    func fetchTabItems() -> [DataSource] {
        let items = SearchTab.allCases.map { tab in
            SearchResultSection.Item.tab(tab)
        }
        return [[SearchResultSection.tab: items]]
    }
}

// MARK: - Fetch & Mapping
extension SearchResultViewModel {
    
    private func fetchSearchResult(tab: SearchTab, query: SearchQuery) -> AnyPublisher<[DataSource], Error> {
        switch tab {
        case .all:
            return self.fetchAllResult(query: query)
        case .image:
            return self.fetchMovieResult(query: query)
                .withUnretained(self)
                .map { owner, dataSources in
                    owner.addTabItems(dataSources)
                }
                .eraseToAnyPublisher()
        case .blog:
            return fetchWebDocumentResult(query: query)
                .withUnretained(self)
                .map { owner, dataSources in
                    owner.addTabItems(dataSources)
                }
                .eraseToAnyPublisher()
        case .movie:
            return self.fetchMovieResult(query: query)
                .withUnretained(self)
                .map { owner, dataSources in
                    owner.addTabItems(dataSources)
                }
                .eraseToAnyPublisher()
        case .webDocument:
            return self.fetchWebDocumentResult(query: query)
                .withUnretained(self)
                .map { owner, dataSources in
                    owner.addTabItems(dataSources)
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func addTabItems(_ dataSources: [DataSource]) -> [DataSource] {
        return self.fetchTabItems() + dataSources
    }
    
    private func fetchMovieResult(query: SearchQuery, offset: Int = 1, count: Int = 10) -> AnyPublisher<[DataSource], Error> {
        return self.searchMovieUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.movie($0)
                }
                return [[.movie: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchWebDocumentResult(query: SearchQuery, offset: Int = 1, count: Int = 10) -> AnyPublisher<[DataSource], Error> {
        return searchWebDocumentUseCase.execute(keyword: query.keyword, offset: offset, count: count, isConnected: query.isNetworking)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.webDocument($0)
                }
                return [[.webDocument: result]]
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchAllResult(query: SearchQuery) -> AnyPublisher<[DataSource], Error> {
        return fetchWebDocumentResult(query: query, count: 3)
            .zip(fetchMovieResult(query: query, count: 3)) { webDocument, movie in
                return self.fetchTabItems() + webDocument + movie
            }
            .eraseToAnyPublisher()
    }
}
