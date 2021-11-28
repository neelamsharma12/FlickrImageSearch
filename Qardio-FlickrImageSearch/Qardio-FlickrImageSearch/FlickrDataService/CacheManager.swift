//
//  CacheManager.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import UIKit

class CacheManager {
    
    // MARK: - variable declaration
    static let shared: CacheManager = CacheManager()
    private let imageCache: NSCache<NSString, UIImage>
    
    // MARK: - Init Methods
    private init(){
        imageCache = NSCache<NSString, UIImage>()
    }
    
    // MARK: - Utility Methods
    func retrieveCachedImage(for key: String) -> UIImage?{
        return self.imageCache.object(forKey: key as NSString)
    }

    func cacheImage(_ image: UIImage, forKey key: String) {
        self.imageCache.setObject(image, forKey: key as NSString)
    }
    
    func isImageCached(for key: String) -> Bool{
        if let _ = self.retrieveCachedImage(for: key){
            return true
        }
        return false
    }
}
