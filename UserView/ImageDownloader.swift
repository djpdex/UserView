//
//  ImageDownloader.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

// A simple wrapper to download user images - designed to be used
// from view and view model layers. This does break the strict communication protocols
// defined in the rest of the architecture, but I feel it's pregamatic as
// images are a view domain specific thing
class ImageDownloader {
    
    // A simple image cache
    private static let simpleCache = NSCache<NSString, UIImage>()
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClient.sharedInstance) {
        self.httpClient = httpClient
    }
    
    func cachedImageFor(urlString: String) -> UIImage? {
        
        if let url = URL(string: urlString), url.lastPathComponent.utf8.count > 0 {
            return ImageDownloader.simpleCache.object(forKey: NSString(string: url.lastPathComponent))
        } else {
            return nil
        }
    }
    
    func downloadImageFor(urlString: String,
                               completion: @escaping (UIImage?) -> Void) {
        
        _ = httpClient.getRequestFor(url: urlString, responseType: .image) { [weak self] (result) in
            switch result {
            case .success(let image):
                guard let image = image as? UIImage else {
                    completion(nil)
                    return
                }
                
                // Add the image to the cache
                if let key = self?.getCacheKeyFor(urlString: urlString) {
                    ImageDownloader.simpleCache.setObject(image, forKey: NSString(string: key))
                }
                
                completion(image)
                
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func getCacheKeyFor(urlString: String) -> String? {
        if let url = URL(string: urlString), url.lastPathComponent.utf8.count > 0 {
            return url.lastPathComponent
        } else {
            return nil
        }
    }
}
