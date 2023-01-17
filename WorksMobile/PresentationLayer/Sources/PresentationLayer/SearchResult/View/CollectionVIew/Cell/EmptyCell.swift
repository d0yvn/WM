//
//  EmptyCell.swift
//  
//
//  Created by USER on 2023/01/17.
//

import UIKit

final class EmptyCell: BaseCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "검색 결과가 없습니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func configureHierarchy() {
        self.contentView.addSubviews([
            titleLabel
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset * 2),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
