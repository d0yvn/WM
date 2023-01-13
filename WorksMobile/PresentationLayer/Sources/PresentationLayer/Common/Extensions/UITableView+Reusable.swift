//
//  UITableView+Reusable.swift
//  
//
//  Created by USER on 2023/01/11.
//

import UIKit

extension UITableView {
    
    func register<T>(_ cellClass: T.Type) where T: UITableViewCell {
        self.register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func register<T>(_ cellClass: T.Type) where T: UITableViewHeaderFooterView {
        self.register(cellClass.self, forHeaderFooterViewReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    func dequeueHeaderFooterView<T>(_ cellClass: T.Type) -> T? where T: UITableViewHeaderFooterView {
        return self.dequeueReusableHeaderFooterView(withIdentifier: cellClass.reuseIdentifier) as? T
    }
}

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
