//
//  UIImageViewExtension.swift
//  
//
//  Created by Stanislav Makushov on 25.04.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func image(from urlString: String, withPlaceholder placeholder: UIImage? = nil, isRounded: Bool = false, progressHandler: ((Double)->())? = nil) {
        
        // check if we already have this image in cache
        if let image = ImageLoader.shared.storedImage(withKey: urlString) {
            //we have this image in cache
            self.image = isRounded ? image.rounded : image
        } else {
            self.image = isRounded ? placeholder?.rounded : placeholder
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            ImageLoader.shared.downloadImage(from: urlString, progressHandler: { (progress) in
                if let handler = progressHandler {
                    handler(progress)
                }
            }, completion: { (image, error) in
                if let completeImage = image {
                    DispatchQueue.main.async {
                        self.image = isRounded ? completeImage.rounded : completeImage
                        activityIndicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                }
            })
        }
    }
    
    func roundImage(_ radius: CGFloat = 0) {
        if radius > 0 {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = false
            self.clipsToBounds = true
        }
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        for view in self.subviews {
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
