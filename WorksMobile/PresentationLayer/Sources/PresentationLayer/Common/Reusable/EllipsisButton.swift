//
//  EllipsisButton.swift
//  
//
//  Created by USER on 2023/01/18.
//

import UIKit

protocol ExternalBrowserDelegate: AnyObject {
    func showExternalBrowser(_ link: String)
}

final class EllipsisButton: UIButton {
    
    init(tintColor: UIColor) {
        super.init(frame: .zero)
        
        self.tintColor = tintColor
        configureAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttribute() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleToFill
        self.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
    }
}
