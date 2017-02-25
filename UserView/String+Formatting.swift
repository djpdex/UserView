//
//  String+Formatting.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

extension String {
    
    func firstCharacterUpperCase() -> String {

        // Check it's not empty of just a single char
        if self == "" {
            return self
        }
        
        if self.startIndex == self.endIndex {
            return self.uppercased()
        }
        
        // The cost of being unicode complete... (rolls eyes)
        let lowercaseString = self.lowercased()
        let range = Range(uncheckedBounds: (lower: lowercaseString.startIndex,
                                            upper: lowercaseString.index(after: lowercaseString.startIndex)))
        
        return lowercaseString.replacingCharacters(in: range ,
                                                   with: String(lowercaseString[lowercaseString.startIndex]).uppercased())
    }
}
