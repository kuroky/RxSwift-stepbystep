//
//  TodoListViewController.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import RxSwift

enum SaveTodoError: Error {
    case cannotSaveToLocalFile
    case iCloudIsNotEnabled
    case cannotReadLocalFile
    case cannotCreateFileOnCloud
}

class TodoListViewController: UIViewController {
    let maxTodoCount    =   5 // 最多新建5个待完成状态
    var todoItems = Variable<[TodoItem]>([])
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var addTodo: UIBarButtonItem!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        
        todoItems.asObservable().subscribe(onNext: {
            [weak self] todos in
            self?.updateUI(todos: todos)
        }).disposed(by: bag)
    }
    
    func setupData() {
        guard let data = try? Data.init(contentsOf: dataFilePath()) else {
            return
        }
        
        guard let list = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            return
        }
        
        guard let items: [TodoItem] = list as? [TodoItem] else {
            return
        }
        
        todoItems.value = items
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    func updateUI(todos: [TodoItem]) {
        clearButton.isEnabled = !todos.isEmpty
        addTodo.isEnabled = todos.filter {
            !$0.isFinished
        }.count < maxTodoCount
        
        let title = todos.isEmpty ? "ToDo" : "\(todos.count) ToDo"
        navigationItem.title = title
        tableView.reloadData()
    }
    
    //MARK:- add
    @IBAction func addTodoListItem(_ sender: Any) {
        let detail = ToDoDetailTableViewController()
        let detailVC = UINavigationController.init(rootViewController: detail)
        detailVC.navigationItem.title = "Add Todo"
        _ = detail.todo.subscribe(
            onNext: {
                [weak self] newTodo in
                self?.todoItems.value.append(newTodo)
            },
            onDisposed: {
                print("finish add")
            }
        )
        present(detailVC, animated: true, completion: nil)
    }
    
    //MARK:- save
    @IBAction func saveTodoList(_ sender: UIButton) {
        _ = saveTodoItems().subscribe(
            onError: { [weak self] error in
                self?.flash(title: "Error", message: error.localizedDescription)
            },
            onCompleted: { [weak self] in
                self?.flash(title: "Success", message: "All Todos are saved on your phone.")
            },
            onDisposed:{ print("Save obj disposed") }
        )
    }
    
    func saveTodoItems() -> Observable<Void> {
        return Observable.create({ observer in
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self.todoItems.value, requiringSecureCoding: false) else {
                observer.onError(SaveTodoError.cannotSaveToLocalFile)
                return Disposables.create()
            }
            
            guard let _ = try? data.write(to: self.dataFilePath(), options: .atomic) else {
                observer.onError(SaveTodoError.cannotSaveToLocalFile)
                return Disposables.create()
            }
            
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    //MARK:- clear
    @IBAction func clearTodoList(_ sender: UIButton) {
        todoItems.value.removeAll()
    }
    
    //MARK:- cloud
    @IBAction func syncToCloud(_ sender: UIButton) {
        _ = syncTodoToCloud().subscribe(
            onNext: {
                self.flash(title: "Success", message: "All todos are synced to: \($0)")
            },
            onError: {
                self.flash(title: "Error", message: "Sync failed due to: \($0.localizedDescription)")
            },
            onDisposed: {
                print("Sync obj disposed")
            }
        )
    }
    
    func syncTodoToCloud() -> Observable<URL> {
        return Observable.create({ observer in
            guard let cloudUrl = self.ubiquityURL("Documents/TodoList") else {
                observer.onError(SaveTodoError.iCloudIsNotEnabled)
                return Disposables.create()
            }
            
            guard let localData = NSData(contentsOf: self.dataFilePath()) else {
                observer.onError(SaveTodoError.cannotReadLocalFile)
                return Disposables.create()
            }
            
            let plist = PlistDocument(fileURL: cloudUrl, data: localData)
            plist.save(to: cloudUrl, for: .forOverwriting, completionHandler: { (success: Bool) -> Void in
                if success {
                    observer.onNext(cloudUrl)
                    observer.onCompleted()
                } else {
                    observer.onError(SaveTodoError.iCloudIsNotEnabled)
                }
            })
            return Disposables.create()
        })
    }
    
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func dataFilePath() -> URL {
        let path = documentsDirectory().appendingPathComponent("TodoList")
        return path
    }
    
    func ubiquityURL(_ filename: String) -> URL? {
        let ubiquityURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        
        if ubiquityURL != nil {
            return ubiquityURL?.appendingPathComponent("\(filename)")
        }
        return nil
    }
}


