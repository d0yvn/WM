//
//  ResizableImageView.swift
//  
//
//  Created by USER on 2023/01/18.
//

import Kingfisher
import UIKit
import Utils

final class ResizableImageView: UIImageView {
    
    func setImage(with urlString: String, size: CGSize) {
        guard let url = URL(string: urlString) else { return }
        
        let resizeImageProcessor = ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
        self.kf.setImage(with: url, options: [.processor(resizeImageProcessor)])
    }
}
