//
//  ExpandFooterView.swift
//  
//
//  Created by USER on 2023/01/16.
//

import DomainLayer
import UIKit
import Utils

protocol ExpandFooterViewDelegate: AnyObject {
    func didTapMoreButton(section: SearchResultSection?)
}

final class ExpandFooterView: BaseCollectionReusableView {
    
    private var section: SearchResultSection?
    
    weak var delegate: ExpandFooterViewDelegate?
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        moreButton.setTitle(nil, for: .normal)
        self.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    override func configureAttributes() {
        self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        self.layer.addBorder([.bottom, .top], color: .gray.withAlphaComponent(0.1), borderWidth: 0.5)
    }
    
    func configureButton(_ section: SearchResultSection) {
        self.section = section
        
        addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        guard let title = section.title else { return }
        moreButton.setTitle("\(title) 더 보기.", for: .normal)
    }
    
    override func bind() {
        moreButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.delegate?.didTapMoreButton(section: self.section)
            }
            .store(in: &cancellable)
    }
}
