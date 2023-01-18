//
//  BlogResultCell.swift
//  
//
//  Created by USER on 2023/01/14.
//

import Combine
import DomainLayer
import UIKit
import Utils

final class BlogResultCell: BaseCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "제목"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.text = "제목"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bloggerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "제목"
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider = DividerView()
    
    override func configureHierarchy() {
        self.contentView.addSubviews([
            titleLabel,
            descriptionLabel,
            bloggerNameLabel,
            postDateLabel,
            divider
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            bloggerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            bloggerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            postDateLabel.leadingAnchor.constraint(equalTo: bloggerNameLabel.trailingAnchor, constant: offset),
            postDateLabel.centerYAnchor.constraint(equalTo: bloggerNameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bloggerNameLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: bloggerNameLabel.bottomAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with item: Blog) {
        self.titleLabel.text = item.title
        self.bloggerNameLabel.text = "\(item.bloggerName) |"
        self.descriptionLabel.text = item.description
        
        let postDate = item.postDate.toDate(type: .yearAndMonthandDate3)?.toString(type: .yearAndMonthandDate2) ?? item.postDate
        
        self.postDateLabel.text = postDate
    }
}
