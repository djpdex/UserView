//
//  JSONParser.swift
//  Popcorn
//
//  Created by Sam Clewclo on 2/6/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class JSONParser: NSObject, Parser {
    
    
    // MARK:- Parser
    
    let type: ParserFactory.ParserType = .JSON
    
    func parseDataToObject(data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    func acceptContentType() -> String? {
        return "application/json"
    }
}
