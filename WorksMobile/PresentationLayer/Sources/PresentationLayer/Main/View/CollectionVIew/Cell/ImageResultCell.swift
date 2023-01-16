//
//  ImageResultCell.swift
//  
//
//  Created by USER on 2023/01/14.
//

import DomainLayer
import Kingfisher
import UIKit

final class ImageResultCell: BaseCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    override func configureHierarchy() {
        self.contentView.addSubviews([
            titleLabel,
            imageView
        ])
    }
    
    override func configureConstraints() {
        
    }
    
    func configure(with item: Image) {
        let url = URL(string: item.thumbnail)
        
        titleLabel.text = item.title
        imageView.kf.setImage(with: url)
    }
}
