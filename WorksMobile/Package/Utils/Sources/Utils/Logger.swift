//
//  Logger.swift
//  
//
//  Created by USER on 2023/01/09.
//

import Foundation

enum Logger {
    
    static func print(_ items: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        Swift.print()
        Swift.print("🟢 Log at \(file.components(separatedBy: "/").last ?? "Some File")")
        Swift.print("🟢 function: \(function), line: \(line)")
        Swift.print("🟢")
        Swift.print("🟢", items)
        Swift.print()
        #endif
    }
    
    static func printArray(_ array: [Any], file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        Swift.print()
        Swift.print("🟢 Log at \(file.components(separatedBy: "/").last ?? "Some File")")
        Swift.print("🟢 function: \(function), line: \(line)")
        Swift.print("🟢")
        for item in array {
            Swift.print("🟢", item)
        }
        Swift.print()
        #endif
    }
}
