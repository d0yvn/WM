//
//  DividerView.swift
//  
//
//  Created by USER on 2023/01/16.
//

import UIKit

final class DividerView: BaseView {
    
    init(color: UIColor = .systemGray, height: CGFloat = 0.5) {
        super.init(frame: .zero)
        
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
