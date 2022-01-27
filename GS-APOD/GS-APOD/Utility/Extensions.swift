//
//  Extensions.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 27/01/22.
//

import Foundation
import UIKit


extension DateFormatter {
    
    /// Return dateFormatter with 'dateFormat' = "YYYY-MM-DD"
    /// - Returns: DateFormatter instance
    class func yyyymmddDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }    
}


extension UIStoryboard {
    
    /// Return the UIViewController object from 'Main' storyboard with given 'identifier'
    /// - Parameter withIdentifier: Identifier of VC in 'Main' storyboard
    /// - Returns: UIViewController instance
    class func instantiateVCFromMain(_ withIdentifier: String) -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }
}
