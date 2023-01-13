//
//  SearchViewModel.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import DomainLayer
import Foundation
import Utils

final public class SearchViewModel: ViewModelType {
    
    private let fetchSearchLogUseCase: FetchSearchLogUseCase
    private let deleteSearchLogUseCase: DeleteSearchLogUseCase
    private let updateSearchLogUseCase: UpdateSearchLogUseCase
    
    struct Input {
        let willUpdateSearchText: AnyPublisher<SearchQuery, Never>
        let willDeleteSearchText: AnyPublisher<String, Never>
        let backButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[SearchLog], Never>
        let typedText: AnyPublisher<String, Never>
    }
    
    var cancellable: Set<AnyCancellable> = []
    weak var coordinator: MainCoordinator?
    
    private var dataSource = CurrentValueSubject<[SearchLog], Never>([])
    
    private let willSearchText: CurrentValueSubject<SearchQuery, Never>
    
    // MARK: - Initailize
    public init(
        fetchSearchUseCase: FetchSearchLogUseCase,
        deleteSearchUseCase: DeleteSearchLogUseCase,
        updateSearchUseCase: UpdateSearchLogUseCase,
        willSearchText: CurrentValueSubject<SearchQuery, Never>
    ) {
        self.fetchSearchLogUseCase = fetchSearchUseCase
        self.deleteSearchLogUseCase = deleteSearchUseCase
        self.updateSearchLogUseCase = updateSearchUseCase
        self.willSearchText = willSearchText
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        fetchSearchLogUseCase.excute()
            .replaceError(with: [])
            .sink { [weak self] output in
                self?.dataSource.send(output)
            }
            .store(in: &cancellable)
        
        input.willUpdateSearchText
            .withUnretained(self)
            .flatMap { owner, query in
                owner.requestUpdateSearchLog(with: query)
            }
            .assertNoFailure()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.willSearchText.send(output)
            }
            .store(in: &cancellable)
        
        input.willDeleteSearchText
            .withUnretained(self)
            .flatMap { owner, keyword in
                owner.deleteSearchLogUseCase.delete(keyword: keyword)
            }
            .replaceError(with: [])
            .sink { [weak self] output in
                self?.dataSource.send(output)
            }
            .store(in: &cancellable)
        
        input.backButtonTap
            .sink { [weak self] in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellable)
        
        let existedSearchText = willSearchText
            .map { $0.keyword }
            .eraseToAnyPublisher()
        
        return Output(
            dataSource: dataSource.eraseToAnyPublisher(),
            typedText: existedSearchText
        )
    }
}

// MARK: - mapping
extension SearchViewModel {
    func requestUpdateSearchLog(with query: SearchQuery) -> AnyPublisher<SearchQuery, Error> {
        return updateSearchLogUseCase.update(keyword: query.keyword)
            .map {
                SearchQuery(keyword: $0, isHistory: query.isHistory)
            }
            .eraseToAnyPublisher()
    }
}
