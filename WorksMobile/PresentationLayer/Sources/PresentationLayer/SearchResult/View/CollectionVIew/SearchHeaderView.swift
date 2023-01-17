//
//  SearchHeaderView.swift
//  
//
//  Created by USER on 2023/01/14.
//

import UIKit

final class SearchHeaderView: BaseCollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dividerView = DividerView()
    
    override func configureHierarchy() {
        self.addSubviews([titleLabel, dividerView])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset * 2),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with item: String) {
        self.titleLabel.text = item
    }
}
