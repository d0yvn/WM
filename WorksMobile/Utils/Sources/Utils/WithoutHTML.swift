//
//  WithoutHTML.swift
//  
//
//  Created by USER on 2023/01/16.
//

import Foundation

@propertyWrapper
public struct WithoutHTML: Hashable {
    
    var value: String = ""
    
    public var wrappedValue: String {
        get {
            self.value
        }
        set {
            self.value = removeHTMLTag(newValue)
        }
    }
    
    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
    private func removeHTMLTag(_ text: String) -> String {
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
}
