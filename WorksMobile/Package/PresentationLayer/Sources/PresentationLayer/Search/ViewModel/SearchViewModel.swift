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
    
    struct Input {
        let updateSearchLog: AnyPublisher<String, Never>
        let deleteSearchLog: AnyPublisher<String, Never>
    }
    
    struct Output {
        let dataSource: AnyPublisher<[SearchLog], Never>
        let search: AnyPublisher<String, Error>
    }
    
    private let fetchSearchLogUseCase: FetchSearchLogUseCase
    private let deleteSearchLogUseCase: DeleteSearchLogUseCase
    private let updateSearchLogUseCase: UpdateSearchLogUseCase
    
    var cancellable: Set<AnyCancellable> = []
    
    private var dataSource = CurrentValueSubject<[SearchLog], Never>([])
    
    public init(
        fetchSearchUseCase: FetchSearchLogUseCase,
        deleteSearchUseCase: DeleteSearchLogUseCase,
        updateSearchUseCase: UpdateSearchLogUseCase
    ) {
        self.fetchSearchLogUseCase = fetchSearchUseCase
        self.deleteSearchLogUseCase = deleteSearchUseCase
        self.updateSearchLogUseCase = updateSearchUseCase
    }
    
    func transform(input: Input) -> Output {
        
        fetchSearchLogUseCase.excute()
            .replaceError(with: [])
            .sink { [weak self] output in
                self?.dataSource.send(output)
            }
            .store(in: &cancellable)
        
        let search = input.updateSearchLog
            .flatMap { text -> AnyPublisher<String, Error> in
                self.updateSearchLogUseCase.update(keyword: text)
            }
            .eraseToAnyPublisher()
        
        input.deleteSearchLog
            .flatMap({ keyword in
                return self.deleteSearchLogUseCase.delete(keyword: keyword)
            })
            .replaceError(with: [])
            .sink { [weak self] output in
                self?.dataSource.send(output)
            }
            .store(in: &cancellable)
        
        return Output(dataSource: dataSource.eraseToAnyPublisher(), search: search)
    }
}
