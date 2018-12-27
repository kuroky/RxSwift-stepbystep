//
//  Flash.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/26.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

extension UIViewController {
    typealias AlertCallback = ((UIAlertAction) -> Void)
    
    func flash(title: String, message: String, callback: AlertCallback? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: callback)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
