//
//  SextionModelType.swift
//  RxExample
//
//  Created by kuroky on 2019/4/23.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
}
