//
//  MovieResultCell.swift
//  
//
//  Created by USER on 2023/01/14.
//

import DomainLayer
import UIKit
import Kingfisher

final class MovieResultCell: BaseCollectionViewCell {
    
    private weak var delegate: ExternalBrowserDelegate?
    
    private var movie: Movie?
    
    private lazy var ellipsisButton = EllipsisButton(tintColor: .white)
    
    private lazy var imageView: ResizableImageView = {
        let imageView = ResizableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pubDateDefaultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.text = "개봉"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.text = "개봉"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actorDefaultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.text = "출연"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.text = "출연"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var partitionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.text = "|"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.pubDateLabel.text = nil
        self.actorLabel.text = nil
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews([
            imageView,
            titleLabel,
            partitionLabel,
            ratingLabel,
            pubDateDefaultLabel,
            pubDateLabel,
            ellipsisButton
        ])
    }
    
    override func configureConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
            imageView.widthAnchor.constraint(equalToConstant: offset * 8)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -offset * 1.5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset * 1.5),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset * 1.5)
        ])
        
        NSLayoutConstraint.activate([
            pubDateDefaultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset * 1.5),
            pubDateDefaultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            pubDateLabel.leadingAnchor.constraint(equalTo: pubDateDefaultLabel.trailingAnchor, constant: offset),
            pubDateLabel.centerYAnchor.constraint(equalTo: pubDateDefaultLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            partitionLabel.centerYAnchor.constraint(equalTo: pubDateDefaultLabel.centerYAnchor),
            partitionLabel.leadingAnchor.constraint(equalTo: pubDateLabel.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: partitionLabel.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: pubDateDefaultLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ellipsisButton.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            ellipsisButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
    }
    
    func configure(with movie: Movie, delegate: ExternalBrowserDelegate?) {
        self.movie = movie
        self.delegate = delegate
        
        titleLabel.text = movie.title
        imageView.setImage(with: movie.image, size: frame.size)
        pubDateLabel.text = movie.pubDate
        ratingLabel.text = "⭐ \(movie.userRating)"
        
        if !movie.actor.isEmpty {
            configureActorLabel(with: movie.actor)
        }
    }
    
    private func configureActorLabel(with actor: String) {
        contentView.addSubviews([actorDefaultLabel, actorLabel])
        
        NSLayoutConstraint.activate([
            actorDefaultLabel.leadingAnchor.constraint(equalTo: pubDateDefaultLabel.leadingAnchor),
            actorDefaultLabel.topAnchor.constraint(equalTo: pubDateDefaultLabel.bottomAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            actorLabel.leadingAnchor.constraint(equalTo: actorDefaultLabel.trailingAnchor, constant: offset),
            actorLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -offset),
            actorLabel.topAnchor.constraint(equalTo: actorDefaultLabel.topAnchor)
        ])
        
        actorLabel.text = actor.components(separatedBy: "|")
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    override func configureAttributes() {
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.borderColor = UIColor.systemGray6.cgColor
        self.contentView.layer.borderWidth = 1
    }
    
    override func bind() {
        ellipsisButton.tapPublisher
            .compactMap { [weak self] _ in
                self?.movie?.link
            }
            .sink { [weak self] in
                self?.delegate?.showExternalBrowser($0)
            }
            .store(in: &cancellable)
    }
}
