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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
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
            pubDateDefaultLabel,
            pubDateLabel
        ])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            pubDateDefaultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            pubDateDefaultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            pubDateLabel.leadingAnchor.constraint(equalTo: pubDateDefaultLabel.trailingAnchor, constant: offset),
            pubDateLabel.centerYAnchor.constraint(equalTo: pubDateDefaultLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
            imageView.widthAnchor.constraint(equalToConstant: offset * 15)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: offset * 15, height: offset * 15)) |> RoundCornerImageProcessor(cornerRadius: 8)
        imageView.kf.setImage(with: URL(string: movie.image), options: [.processor(processor)])
        pubDateLabel.text = movie.pubDate
        
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
}
