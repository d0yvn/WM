//
//  WMSearchView.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import UIKit

final class WMSearchView: BaseView {
    
    // MARK: - Properties
    let searchSubject = PassthroughSubject<String, Never>()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGray
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGreen
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어 입력"
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .white
        button.layer.cornerRadius = self.offset
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isUserInteractionEnabled = false
        button.alpha = 0
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var divier: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubviews([
            backButton,
            searchImageView,
            textField,
            deleteButton,
            divier
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset * 1.5),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: offset * 4),
            backButton.heightAnchor.constraint(equalToConstant: offset * 4)
        ])
        
        NSLayoutConstraint.activate([
            searchImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(offset * 1.5)),
            searchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchImageView.widthAnchor.constraint(equalToConstant: offset * 4),
            searchImageView.heightAnchor.constraint(equalToConstant: offset * 4)
        ])

        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: searchImageView.leadingAnchor, constant: -offset),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: offset * 2),
            deleteButton.widthAnchor.constraint(equalToConstant: offset * 2)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: offset),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: offset * 4),
            textField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -offset)
        ])
        
        NSLayoutConstraint.activate([
            divier.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divier.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divier.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divier.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func configureAttributes() {
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        configureTextField()
    }
    
    override func bind() {
        deleteButton.tapPublisher
            .sink { [weak self] _ in
                self?.textField.text = nil
            }
            .store(in: &cancellable)
        
        textField.textPublisher
            .map(\.isEmpty)
            .sink { [weak self] isEnabled in
                self?.configureDeleteButton(!isEnabled)
            }
            .store(in: &cancellable)
        
        textField.shouldReturnPublisher
            .compactMap { [weak self] in
                self?.textField.text
            }
            .sink { [weak self] in
                self?.textField.text = nil
                self?.searchSubject.send($0)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UIButton
extension WMSearchView {
    private func configureDeleteButton(_ isEnabled: Bool) {
        deleteButton.isUserInteractionEnabled = isEnabled
        deleteButton.alpha = isEnabled ? 1.0 : 0
    }
}

// MARK: - TextField
extension WMSearchView {
    
    private func configureTextField() {
        guard let text = textField.text else {
            return
        }
        
        let isEnabled = text.isEmpty
        configureDeleteButton(!isEnabled)
    }
    
    func updateTextField(_ text: String) {
        self.textField.text = text
        
        configureDeleteButton(!text.isEmpty)
    }
}
