//
//  AlertController.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 27/01/22.
//

import Foundation
import UIKit


class AlertController {
    
    /// Show alertController with one textField and buttons
    /// - Parameters:
    ///   - title: alert title text
    ///   - message: alert message text
    ///   - placeholder: textField's placeholder text
    ///   - buttonTitles: buttonTitles list
    ///   - completion: callback handler
    /// - Returns: UIAlertController instance
    class func alertControllerWithTitleMessageAndTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, buttonTitles: String..., completion: @escaping (Int, String?) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        for (index, option) in buttonTitles.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { [weak alertController] (action) in
                completion(index, alertController?.textFields?[0].text)
            }))
        }
        return alertController
    }
    
    /// Show alertController with buttons
    /// - Parameters:
    ///   - title: alert title text
    ///   - message: alert message text
    ///   - buttonTitles: buttonTitles list
    ///   - completion: callback handler
    /// - Returns: UIAlertController instance
    class func alertControllerWithTitleAndMessage(title: String? = nil, message: String? = nil, buttonTitles: String..., completion: ((Int) -> Void)? = nil ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in buttonTitles.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion?(index)
            }))
        }
        return alertController
    }
}
