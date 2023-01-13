//
//  ViewModelType.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var cancellable: Set<AnyCancellable> { get }
    
    func transform(input: Input) -> Output
}
