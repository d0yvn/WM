//
//  BaseTableViewHeaderFooterView.swift
//  
//
//  Created by USER on 2023/01/12.
//

import Combine
import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - Methods
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        configureAttributes()
        configureHierarchy()
        configureConstraints()
        bind()
    }

    public func configureHierarchy() {}
    public func configureConstraints() {}
    public func configureAttributes() {}
    public func bind() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
}
