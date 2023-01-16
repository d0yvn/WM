//
//  MainViewModel.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import DomainLayer
import Foundation
import Utils

final public class MainViewModel: ViewModelType {
    
    typealias DataSource = [SearchResultSection: [SearchResultSection.Item]]
    
    private let searchMovieUseCase: SearchMovieUseCase
    private let searchImageUseCase: SearchImageUseCase
    private let searchBlogUseCase: SearchBlogUseCase
    private let searchWebDocumentUseCase: SearchWebDocumentUseCase
    
    struct Input {
        let showSearchView: AnyPublisher<Void, Never>
        let showDetailView: AnyPublisher<String, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[DataSource], Never>
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    private let subject = CurrentValueSubject<SearchQuery, Never>(SearchQuery(keyword: "", isHistory: false))
    
    weak var coordinator: MainCoordinator?
    
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
        
        input.showSearchView
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.showSearchViewController(subject: self.subject)
            }
            .store(in: &cancellable)
        
        input.showDetailView
            .sink { [weak self] link in
                self?.coordinator?.showDetailViewController(link)
            }
            .store(in: &cancellable)
        
        subject
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellable)
        
        let dataSource = searchWebDocumentUseCase.execute(keyword: "korea", offset: 1, count: 10, isConnected: true)
            .map { items -> [DataSource] in
                let result = items.map {
                    SearchResultSection.Item.webDocument($0)
                }
                return self.generateTabItems() + [[.webDocument: result]]
            }
            .assertNoFailure()
            .eraseToAnyPublisher()

        return Output(dataSource: dataSource)
    }
}

extension MainViewModel {
    func generateTabItems() -> [DataSource] {
        
        let items = SearchTab.allCases.map { tab in
            SearchResultSection.Item.tab(tab)
        }

        return [[SearchResultSection.tab: items]]
    }
}
