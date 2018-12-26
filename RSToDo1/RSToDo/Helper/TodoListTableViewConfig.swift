//
//  TodoListTableViewConfig.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! TodoListCell
        cell.configItem(item: self.todoItems.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = todoItems.value[indexPath.row]
        item.isFinished = !item.isFinished
        todoItems.value[indexPath.row] = item
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detail = ToDoDetailTableViewController()
        detail.todoItem = todoItems.value[indexPath.row]
        let detailVC = UINavigationController.init(rootViewController: detail)
        detailVC.navigationItem.title = "Edit Todo"
        _ = detail.todo.subscribe(
            onNext: { [weak self] newTodo in
                self?.todoItems.value[indexPath.row] = newTodo
            },
            onDisposed: {
                print("finish edit")
            }
        )
        present(detailVC, animated: true, completion: nil)
    }
}
