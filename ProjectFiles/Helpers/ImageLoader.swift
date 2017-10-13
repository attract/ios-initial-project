//
//  ImageLoader.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import UIKit
import SDWebImage

class ImageLoader: NSObject {
    class var shared: ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func storedImage(withKey key: String) -> UIImage? {
        return SDImageCache.shared().imageFromDiskCache(forKey: key)
    }
    
    func downloadImage(from urlString: String, progressHandler: ((Double)->())? = nil, completion: @escaping ((UIImage?,Error?)->Void)) {
        if let image = self.storedImage(withKey: urlString) {
            //we have this image in cache
            completion(image, nil)
        } else {
            if let url = URL(string: urlString) {
                SDWebImageDownloader.shared().shouldDecompressImages = false
                
                SDWebImageDownloader.shared().downloadImage(with: url, options: [], progress: { (receivedSize, expectedSize) in
                    if let handler = progressHandler {
                        DispatchQueue.main.async {
                            handler(Double(receivedSize)/Double(expectedSize))
                        }
                    }
                }, completed: { (image, data, error, isFinished) in
                    DispatchQueue.main.async {
                        if isFinished, let completeImage = image {
                            SDImageCache.shared().store(completeImage, forKey: urlString)
                            completion(completeImage, error)
                        } else {
                            completion(image, error)
                        }
                    }
                })
            }
        }
    }
    
    func clearCache() {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
}
