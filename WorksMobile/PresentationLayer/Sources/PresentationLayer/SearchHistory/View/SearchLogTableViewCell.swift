//
//  SearchLogTableViewCell.swift
//  
//
//  Created by USER on 2023/01/11.
//

import DomainLayer
import UIKit
import Utils

public protocol SearchLogTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(keyword: String)
}

final public class SearchLogTableViewCell: BaseTableViewCell {
    
    weak var delegate: SearchLogTableViewCellDelegate?
    
    private var searchLog: SearchLog?
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "검색 히스토리"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override func configureAttributes() {
        self.selectionStyle = .none
    }
    
    public override func configureHierarchy() {
        self.contentView.addSubviews([
            searchImageView,
            titleLabel,
            deleteButton
        ])
    }
    
    public override func configureConstraints() {
        
        NSLayoutConstraint.activate([
            searchImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset * 2),
            searchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchImageView.widthAnchor.constraint(equalToConstant: self.offset * 3),
            searchImageView.heightAnchor.constraint(equalToConstant: self.offset * 3)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.searchImageView.trailingAnchor, constant: offset * 1)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset * 2)
        ])
    }
    
    public func configure(searchLog: SearchLog) {
        self.searchLog = searchLog
        self.titleLabel.text = searchLog.keyword
    }
    
    public override func bind() {
        deleteButton.tapPublisher
            .compactMap { [weak self] in
                self?.searchLog?.keyword
            }
            .sink(receiveValue: { [weak self] keyword in
                self?.delegate?.didTapDeleteButton(keyword: keyword)
            })
            .store(in: &cancellable)
    }
}
