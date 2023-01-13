//
//  CoreDataError.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

public enum CoreDataError: Error {
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
    case clearError(String)
}
