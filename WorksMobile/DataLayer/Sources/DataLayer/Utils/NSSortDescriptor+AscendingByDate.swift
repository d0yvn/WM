//
//  NSSortDescriptor+AscendingByDate.swift
//  
//
//  Created by USER on 2023/01/10.
//

import CoreData

extension NSSortDescriptor {
    
    static let assendingByDate: NSSortDescriptor = {
        return NSSortDescriptor(key: "latestDate", ascending: false)
    }()
}
