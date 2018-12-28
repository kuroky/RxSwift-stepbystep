//
//  Todo.swift
//  Todos
//
//  Created by kuroky on 2018/12/28.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

class Todo {
    var id: UInt?
    var title: String
    var completed: Bool
    
    init(id: UInt, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    required init?(json: [String: Any]) {
        guard let todoId = json["id"] as? UInt,
        let title = json["title"] as? String,
        let completed = json["completed"] as? Bool else {
            return nil
        }
        
        self.id = todoId
        self.title = title
        self.completed = completed
    }
}

extension Todo: CustomStringConvertible {
    var description: String {
        return "ID: \(self.id ?? 0), " +
            "title: \(self.title)" +
            "completed: \(self.completed)"
    }
}
