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
    
    private let searchMovieUseCase: SearchMovieUseCase
    private let searchImageUseCase: SearchImageUseCase
    private let searchBlogUseCase: SearchBlogUseCase
    private let searchWebDocumentUseCase: SearchWebDocumentUseCase
    
    struct Input {
        let searchViewTrigger: AnyPublisher<Void, Never>
        let showDetailView: AnyPublisher<String, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[DataSource], Error>
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    private var offset: Int = 1
    
    private let searchInput = PassthroughSubject<SearchQuery, Never>()
    
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
        
        let dataSource = searchInput
            .withUnretained(self)
            .flatMap { owner, query in
                owner.fetchAllResult(query: query)
            }
            .eraseToAnyPublisher()

        return Output(dataSource: dataSource)
    }
}

extension SearchResultViewModel {
    
    private func fetchTabItems() -> [DataSource] {
        let items = SearchTab.allCases.map { tab in
            SearchResultSection.Item.tab(tab)
        }
        return [[SearchResultSection.tab: items]]
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
