//
//  PlistDocument.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/26.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

class PlistDocument: UIDocument {
    var plistData: NSData!
    
    init(fileURL: URL, data: NSData) {
        super.init(fileURL: fileURL)
        self.plistData = data
    }
    
    override func contents(forType typeName: String) throws -> Any {
        return plistData
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let userContent = contents as? NSData else {
            return
        }
        plistData = userContent
    }
}
