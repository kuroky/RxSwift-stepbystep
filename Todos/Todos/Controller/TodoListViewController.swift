//
//  TodoListViewController.swift
//  Todos
//
//  Created by kuroky on 2018/12/28.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift

class TodoListViewController: UITableViewController {

    var todoList = [Todo]()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestData()
    }
    
    func setupData() {
        
    }
    
    func setupUI() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Todo")
    }
    
    func requestData() {
        let todoId: Int? = nil
        Observable.of(todoId).map { tid in
            return TodoRouter.get(tid)
            }
            .flatMap { route in
                return Todo.getList(from: route)
            }
            .subscribe(onNext: { (todos: [[String: Any]]) in
                self.todoList = todos.compactMap{ Todo(json: $0) }
                self.tableView.reloadData()
            }, onError: {error in
                print(error.localizedDescription)
            })
            .disposed(by: bag)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo", for: indexPath)

        let title = todoList[indexPath.row].title
        let attributeString = NSMutableAttributedString(string: title)
        
        if todoList[indexPath.row].completed {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        cell.textLabel?.attributedText = attributeString
        return cell
    }

}
