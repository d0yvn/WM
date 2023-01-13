//
//  SearchLogTableHeaderView.swift
//  
//
//  Created by USER on 2023/01/12.
//

import UIKit

final class SearchLogTableHeaderView: BaseTableViewHeaderFooterView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkText
        label.text = "최근 검색어"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteAllLogButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func configureHierarchy() {
        self.addSubviews([
            titleLabel,
            deleteAllLogButton
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset * 2)
        ])
        
        NSLayoutConstraint.activate([
            deleteAllLogButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteAllLogButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset * 2)
        ])
    }
}
