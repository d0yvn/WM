//
//  MainDependency.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Foundation

public protocol MainDependency: AnyObject {
    func searchDependencies() -> SearchViewModel?
}
