//
//  MainViewController.swift
//  WorksMobile
//
//  Created by USER on 2023/01/06.
//

import Combine
import UIKit
import Utils

public final class MainViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: MainViewModel
    public weak var dependency: MainDependency?
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("ShowSearchHistories", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    // MARK: - LifeCycle
    public init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func configureHierarchy() {
        self.view.addSubviews([button])
    }
    
    public override func configureConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    public override func bind() {
        let input = MainViewModel.Input(showSearchView: self.button.tapPublisher
            .eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
    }
}
