//
//  TodoItem.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

class TodoItem: NSObject, NSCoding {
    var name: String = ""
    var isFinished: Bool = false
    
    init(name: String, isFinished: Bool) {
        self.name = name
        self.isFinished = isFinished
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        isFinished = aDecoder.decodeBool(forKey: "isFinished")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isFinished, forKey: "isFinished")
    }
}
