//
//  ExpandFooterView.swift
//  
//
//  Created by USER on 2023/01/16.
//

import UIKit

final class ExpandFooterView: BaseCollectionReusableView {
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func configureAttributes() {
        self.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    override func configureHierarchy() {
        addSubview(moreButton)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
