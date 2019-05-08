//
//  ViewController.swift
//  RSAppTest
//
//  Created by kuroky on 2018/12/24.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todoList: String = "https://jsonplaceholder.typicode.com/todos"
        
        Alamofire.request(todoList).responseJSON { (response) in
            print(response)
        }
    }
    
    
}

