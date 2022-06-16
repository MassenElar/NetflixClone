//
//  ImageCache.swift
//  NetflixClone
//
//  Created by developer on 6/14/22.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    
    let cache: NSCache<NSString, UIImage> = NSCache()
    
    func addImage(key: NSString, image: UIImage) {
        self.cache.setObject(image, forKey: key)
    }
    
    func getImage(key: NSString) -> UIImage? {
        return self.cache.object(forKey: key)
    }
    
    func loadImage(from urlString: String, completionHandler: @escaping (UIImage) -> ()) {
        guard let url = URL(string: urlString) else {return}
        let imageUrl = urlString as NSString
        
        if let cashedImage = self.getImage(key: imageUrl) {
            DispatchQueue.main.async {
                completionHandler(cashedImage)
            }
        } else {
            ImageRequest(url: url).startRequest { image in
                if let image = image {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                    self.cache.setObject(image, forKey: urlString as NSString)
                }
            }
        }
    }
}
