//
//  UIViewController+Extension.swift
//  RxExample
//
//  Created by kuroky on 2019/4/19.
//  Copyright © 2019 Emucoo. All rights reserved.
//

enum RxExampleError: Error {
    case storyBoardNotFound
    case storyBoardNameNotMatch
}

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T>(sbName: String, type: T.Type) throws -> T {
        
        guard let _ = Bundle.main.path(forResource: sbName, ofType: "storyboardc") else {
            throw RxExampleError.storyBoardNotFound
        }
        
        guard let object = UIStoryboard.init(name: sbName, bundle: nil).instantiateInitialViewController() else {
            throw RxExampleError.storyBoardNotFound
        }
        
        guard let returnValue = object as? T else {
            throw RxExampleError.storyBoardNameNotMatch
        }
        
        return returnValue
    }
}
