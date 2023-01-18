//
//  SearchLogTableHeaderView.swift
//  
//
//  Created by USER on 2023/01/12.
//

import UIKit

protocol SearchLogTableHeaderViewDelegate: AnyObject {
    func didTapAllDelete()
}

final class SearchLogTableHeaderView: BaseTableViewHeaderFooterView {
    
    weak var delegate: SearchLogTableHeaderViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        label.text = "최근 검색어"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func configureHierarchy() {
        self.addSubviews([
            titleLabel,
            deleteAllButton
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset * 1.5)
        ])
        
        NSLayoutConstraint.activate([
            deleteAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset)
        ])
    }
    
    override func bind() {
        deleteAllButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.didTapAllDelete()
            }
            .store(in: &cancellable)
    }
}
