//
//  WebDocumentResultCell.swift
//  
//
//  Created by USER on 2023/01/14.
//

import DomainLayer
import UIKit

final class WebDocumentResultCell: BaseCollectionViewCell {
    
    private weak var delegate: ExternalBrowserDelegate?
    
    private var webDocument: WebDocument?
    
    private lazy var ellipsisButton = EllipsisButton(tintColor: .gray)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.text = "제목"
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dividerView = DividerView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([
            titleLabel,
            descriptionLabel,
            dividerView,
            ellipsisButton
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offset),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset * 2)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ellipsisButton.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            ellipsisButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
    }
    
    func configure(with item: WebDocument, delegate: ExternalBrowserDelegate?) {
        self.webDocument = item
        self.delegate = delegate
        
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
    
    override func bind() {
        ellipsisButton.tapPublisher
            .compactMap { [weak self] _ in
                self?.webDocument?.link
            }
            .sink { [weak self] in
                self?.delegate?.showExternalBrowser($0)
            }
            .store(in: &cancellable)
    }
}
