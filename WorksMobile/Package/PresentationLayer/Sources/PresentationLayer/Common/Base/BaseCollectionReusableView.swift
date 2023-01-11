//
//  BaseCollectionReusableView.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import UIKit

public class BaseCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
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

