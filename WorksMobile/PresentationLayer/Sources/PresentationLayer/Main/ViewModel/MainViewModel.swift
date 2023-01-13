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
    
    struct Input {
        let showSearchView: AnyPublisher<Void, Never>
    }
    
    struct Output {
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    private let subject = CurrentValueSubject<SearchQuery, Never>(SearchQuery(keyword: "", isHistory: false))
    
    weak var coordinator: MainCoordinator?
    
    public init() { }
    
    func transform(input: Input) -> Output {
        
        input.showSearchView
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.showSearchViewController(subject: self.subject)
            }
            .store(in: &cancellable)
        
        self.subject
            .sink { value in
                self.coordinator?.popViewController()
                Logger.print(value)
            }
            .store(in: &cancellable)
        
        return Output()
    }
}
