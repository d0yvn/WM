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
    }
    
    struct Output {
    }
    
    var cancellable: Set<AnyCancellable> = []
    
    public init(
    
    ) {

    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
