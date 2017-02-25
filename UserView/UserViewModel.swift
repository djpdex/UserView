//
//  UserViewModel.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class UserViewModel {
    
    let user: User
    let imageDownloader: ImageDownloader
    
    init(user: User, imageDownloader: ImageDownloader = ImageDownloader()) {
        self.user = user
        self.imageDownloader = imageDownloader
    }
    
    var name: String {
        let name = user.name
        return "\(name.title.firstCharacterUpperCase()) \(name.first.firstCharacterUpperCase()) \(name.last.firstCharacterUpperCase())"
    }
    
    var dob: String {
        return Formatters.stringFromDate(date: user.dob)
    }
    
    var gender: String {
        return user.gender
    }
    
    func userImage(completion: @escaping (UIImage?) -> ()) {
        
        if let image = imageDownloader.cachedImageFor(urlString: user.thumbnailImageURL) {
            completion(image)
        } else {
            imageDownloader.downloadImageFor(urlString: user.thumbnailImageURL, completion: { (image) in
                completion(image)
            })
        }
    }
}
