//
//  ParserFactory.swift
//  Popcorn
//
//  Created by Sam Clewclo on 2/6/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

protocol Parser {
    
    func parseDataToObject(data: Data) throws -> Any
    func acceptContentType() -> String?
    var type: ParserFactory.ParserType { get }
}


class ParserFactory: NSObject {
    
    enum ParserType {
        case JSON
        case image
    }
    
    func getParserFor(parserType: ParserType) ->  Parser {
        
        switch parserType {
        case .JSON:
            return JSONParser()
        case .image:
            return ImageParser()
        }
    }
}
