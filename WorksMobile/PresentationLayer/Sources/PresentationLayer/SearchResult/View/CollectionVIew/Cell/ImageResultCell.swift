//
//  ImageResultCell.swift
//  
//
//  Created by USER on 2023/01/14.
//

import DomainLayer
import Kingfisher
import UIKit
import Utils

final class ImageResultCell: BaseCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: ResizableImageView = {
        let imageView = ResizableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews([imageView])
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with item: Image) {
        imageView.setImage(with: item.thumbnail, size: frame.size)
    }
}
