//
//  SearchTabViewCell.swift
//
//  Created by USER on 2023/01/15.
//

import DomainLayer
import UIKit
import Utils

final class SearchTabViewCell: BaseCollectionViewCell {
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet { selectedUpdate() }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -offset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset)
        ])
    }
    
    private func selectedUpdate() {
        self.titleLabel.textColor = self.isSelected ? .systemGreen : .black
    }
    
    func configure(with item: SearchTab) {
        self.titleLabel.text = item.title
    }
}
