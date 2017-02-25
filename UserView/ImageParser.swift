//
//  ImageParser.swift
//  Popcorn
//
//  Created by Sam Clewclo on 2/7/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class ImageParser: Parser {
    
    let kImageErrorDomain = "ImageErrorDomain"
    
    // MARK:- Parser
    
    let type: ParserFactory.ParserType = .JSON
    
    func parseDataToObject(data: Data) throws -> Any {
        
        if let image = UIImage(data: data, scale: UIScreen.main.scale) {
            return image
        } else {
            throw NSError(domain: kImageErrorDomain,
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey:"Failed to parse image"])
        }
    }
    
    func acceptContentType() -> String? {
        return nil
    }
}
