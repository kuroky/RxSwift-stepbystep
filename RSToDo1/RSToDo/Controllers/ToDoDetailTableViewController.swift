//
//  ToDoDetailTableViewController.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift

class ToDoDetailTableViewController: UIViewController {
    fileprivate let todoSubject = PublishSubject<TodoItem>()
    var todo: Observable<TodoItem> {
        return todoSubject.asObserver()
    }
    
    var todoItem: TodoItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {
        if let todoItem = todoItem {
            nameTextField.text = todoItem.name
            statusSwitch.isOn = todoItem.isFinished
        }
        else {
            todoItem = TodoItem(name: "", isFinished: false)
        }
    }
    
    func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(clickCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(clickConfirm))
    }
    
    @objc func clickCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickConfirm() {
        todoItem.name = nameTextField.text!
        todoItem.isFinished = statusSwitch.isOn
            
        todoSubject.onNext(todoItem)
        todoSubject.onCompleted()
        dismiss(animated: true, completion: nil)
    }
}
