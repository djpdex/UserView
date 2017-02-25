//
//  Name.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

class Name {
    
    let kTitleKey = "title"
    let kFirstKey = "first"
    let kLastKey = "last"
    
    let title: String
    let first: String
    let last: String
    
    init?(JSON: [String : String]) {
        
        guard let title = JSON[kTitleKey],
            let first = JSON[kFirstKey],
            let last = JSON[kLastKey] else {
                return nil
        }
        
        self.title = title
        self.first = first
        self.last = last
    }
}

/*
 {
 "title": "mr",
 "first": "romain",
 "last": "hoogmoed"
 }
*/
