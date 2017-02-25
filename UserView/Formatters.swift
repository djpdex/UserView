//
//  Formatters.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class Formatters: NSObject {

    private static let dateWithoutTimezoneFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func dateFromDateWithoutTimeZoneString(dateString: String) -> Date? {
        return dateWithoutTimezoneFormatter.date(from: dateString)
    }
    
    static func stringFromDate(date: Date) -> String {
        return dateWithoutTimezoneFormatter.string(from: date)
    }
}
