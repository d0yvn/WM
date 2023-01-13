//
//  UIView+Offset.swift
//  
//
//  Created by USER on 2023/01/11.
//

import UIKit

extension UIView {
    var offset: CGFloat {
        return UIScreen.main.bounds.width / 50
    }
}

extension UIViewController {
    var offset: CGFloat {
        return self.view.offset
    }
}
