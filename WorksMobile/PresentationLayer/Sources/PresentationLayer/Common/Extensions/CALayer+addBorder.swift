//
//  CALayer+addBorder.swift
//  
//
//  Created by USER on 2023/01/17.
//

import UIKit

extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, borderWidth: CGFloat) {
        edges.forEach { edge in
            let border = CALayer()
            switch edge {
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: borderWidth, height: frame.height)
            case .right:
                border.frame = CGRect.init(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
