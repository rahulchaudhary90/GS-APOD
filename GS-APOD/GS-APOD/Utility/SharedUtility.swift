//
//  SharedUtility.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 27/01/22.
//

import Foundation


class SharedUtility {
    
    static let shared = SharedUtility()
    private let dateFormatter = DateFormatter.yyyymmddDateFormatter()
    
    private init() {}
    
    /// Return the date or nil from given string
    /// - Parameter str: date string in 'YYYY-MM-DD' format
    /// - Returns: Date instance or nil
    func getDateFrom(str: String?) -> Date? {
        guard let dateStr = str else {
            return nil
        }
        return dateFormatter.date(from: dateStr)
    }
}
