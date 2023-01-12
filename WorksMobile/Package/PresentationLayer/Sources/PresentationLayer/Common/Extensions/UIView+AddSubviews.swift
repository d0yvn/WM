//
//  UIView+AddSubviews.swift
//  
//
//  Created by USER on 2023/01/11.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview)
    }
}
