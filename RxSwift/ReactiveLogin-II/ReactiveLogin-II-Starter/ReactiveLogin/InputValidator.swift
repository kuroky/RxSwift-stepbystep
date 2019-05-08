//
//  InputValidator.swift
//  ReactiveLogin
//
//  Created by Mars on 5/21/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import Foundation

class InputValidator {
    class func isValidEmail(email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        
        let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$",
                                          options: .caseInsensitive)
        
        if let re = re {
            let range = NSMakeRange(0, email.lengthOfBytes(using: .utf8))
            let result = re.matches(in: email, options: .reportProgress, range: range)
            return result.count > 0
        }
        
        return false
    }
    
    class func isValidPassword(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        return password.count >= 1
    }
    
    class func isValidDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let compare = calendar.compare(date, to: Date(), toGranularity: .day)
        
        return compare == .orderedAscending
    }
}
