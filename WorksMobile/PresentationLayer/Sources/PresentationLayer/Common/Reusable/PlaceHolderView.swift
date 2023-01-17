//
//  PlaceHolderView.swift
//  
//
//  Created by USER on 2023/01/17.
//

import UIKit

enum PlaceHolderStatus {
    case notStart
    case fail
    case empty
    
    var title: String {
        switch self {
        case .notStart:
            return "검색어를 입력하여\n검색을 시작해주세요"
        case .fail:
            return "알 수 없는 문제로 검색에 실패하였습니다."
        case .empty:
            return "검색 결과가 없습니다."
        }
    }
}

final class PlaceHolderView: BaseView {
    
    // MARK: - UI
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    // MARK: - Initializers
    init(status: PlaceHolderStatus) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.text = status.title
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(descriptionLabel)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -offset * 5)
        ])
    }
    
    func updateDescription(_ status: PlaceHolderStatus) {
        self.isHidden = false
        self.descriptionLabel.text = status.title
    }
}
