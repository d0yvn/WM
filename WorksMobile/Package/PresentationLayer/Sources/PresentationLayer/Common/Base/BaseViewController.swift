//
//  BaseViewController.swift
//  
//
//  Created by USER on 2023/01/11.
//

import Combine
import UIKit

public class BaseViewController: UIViewController {
    
    // MARK: - Properties
    var cancellable: Set<AnyCancellable> = []
    
    private var indicator: UIActivityIndicatorView?
    
    // MARK: - Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
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
    required init(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
}

// MARK: - Indicator
extension BaseViewController {
    
    public func showFullSizeIndicator() {
        let indicator = createIndicator()
        self.indicator = indicator
        
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.heightAnchor.constraint(equalToConstant: 100),
            indicator.widthAnchor.constraint(equalToConstant: 100),
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        indicator.startAnimating()
    }
    
    public func hideFullSizeIndicator() {
        self.indicator?.stopAnimating()
        self.indicator?.removeFromSuperview()
        self.indicator = nil
    }
    
    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .black.withAlphaComponent(0.7)
        indicator.color = .white
        indicator.layer.cornerRadius = 20
        return indicator
    }
}
