//
//  DividerView.swift
//  
//
//  Created by USER on 2023/01/16.
//

import UIKit

final class DividerView: BaseView {
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .lightGray
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
