//
//  WMSearchView.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import UIKit
import Utils

final class WMSearchView: BaseView {
    
    // MARK: - Properties
    enum ViewType {
        case back
        case icon
        
        var image: UIImage? {
            switch self {
            case .back:
                return UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate)
            case .icon:
                return UIImage(named: "icon")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    let searchSubject = PassthroughSubject<String, Never>()
    
    private var type: ViewType {
        didSet { configure(type) }
    }
    
    lazy var logoButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemGray5
        configuration.baseForegroundColor = .white
        
        let image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular, scale: .small))
        configuration.image = image
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        configuration.cornerStyle = .dynamic
        
        button.configuration = configuration
        button.layer.cornerRadius = offset
        button.alpha = 0
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var divier = DividerView(color: .systemGreen, height: 1)
    
    init(type: ViewType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubviews([
            logoButton,
            searchButton,
            textField,
            deleteButton,
            divier
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        NSLayoutConstraint.activate([
            logoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset * 1.5),
            logoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoButton.widthAnchor.constraint(equalToConstant: offset * 4),
            logoButton.heightAnchor.constraint(equalToConstant: offset * 4)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(offset * 1.5)),
            searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: offset * 4),
            searchButton.heightAnchor.constraint(equalToConstant: offset * 4)
        ])

        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -offset),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: offset * 2),
            deleteButton.widthAnchor.constraint(equalToConstant: offset * 2)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: logoButton.trailingAnchor, constant: offset),
            textField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -offset),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: offset * 4)
        ])
        
        NSLayoutConstraint.activate([
            divier.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divier.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divier.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
        
        searchButton
            .tapPublisher
            .merge(with: textField.shouldReturnPublisher)
            .compactMap { [weak self] in
                self?.textField.text
            }
            .filter { !$0.isEmpty }
            .sink { [weak self] in
                self?.searchSubject.send($0)
            }
            .store(in: &cancellable)
    }
    
    func configure(_ type: ViewType) {
        textField.isUserInteractionEnabled = type == .back
        searchButton.isEnabled = type == .back
        logoButton.setImage(type.image, for: .normal)
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
    
    func updateReponder() {
        self.textField.becomeFirstResponder()
    }
}
