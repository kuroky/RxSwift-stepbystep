//
//  TodoListViewController.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift

class TodoListViewController: UIViewController {
    var dataList: [TodoItem] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {
        guard let data = UserDefaults.standard.object(forKey: "TodoItems") as? Data else {
            return
        }
        
        guard let list = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            return
        }
        
        guard let items: [TodoItem] = list as? [TodoItem] else {
            return
        }
        
        dataList = items
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    @IBAction func addTodoListItem(_ sender: Any) {
        let insertIndex = dataList.count
        let item = TodoItem(name: "Todo Demo", isFinished: false)
        dataList.append(item)
        
        let indexPath = IndexPath(row: insertIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func saveTodoList(_ sender: UIButton) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: dataList, requiringSecureCoding: false) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: "TodoItems")
    }
    
    @IBAction func clearTodoList(_ sender: UIButton) {
        dataList.removeAll()
        tableView.reloadData()
    }
}


