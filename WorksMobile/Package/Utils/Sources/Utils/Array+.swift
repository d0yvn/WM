//
//  Array+.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Foundation

extension Array {
    subscript (safe index: Array.Index) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let element = newValue else { return }
            self[index] = element
        }
    }
}
