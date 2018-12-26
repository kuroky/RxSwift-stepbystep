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
    
    fileprivate let images = Variable<[UIImage]>([])
    fileprivate var todoCollage: UIImage?
    
    fileprivate let todoSubject = PublishSubject<TodoItem>()
    var todo: Observable<TodoItem> {
        return todoSubject.asObserver()
    }
    var bag = DisposeBag()
    
    var todoItem: TodoItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var memoButton: UIButton!
    
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
            todoItem = TodoItem(name: "", isFinished: false, pictureMemoFilename: "")
        }
        
        images.asObservable().subscribe(
            onNext: { [weak self] images in
                guard let `self` = self else { return }
                guard !images.isEmpty else {
                    self.resetMemoBtn()
                    return
                }
                
                self.todoCollage = UIImage.collage(images: images, in: self.memoButton.frame.size)
                self.setMemoBtn(bkImage: self.todoCollage ?? UIImage())
            }
        ).disposed(by:bag)
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
    
    @IBAction func addPictureMemos(_ sender: UIButton) {
        
        images.value.removeAll()
        
        let layout = UICollectionViewFlowLayout.init()
        let width = (UIScreen.main.bounds.size.width - 40) * 0.25
        layout.itemSize = CGSize(width: width, height: width)
        let photoVC = PhotoCollectionViewController.init(collectionViewLayout: layout)
        navigationController?.pushViewController(photoVC, animated: true)
        
        _ = photoVC.selectedPhotos.subscribe(
            onNext: { image in
                self.images.value.append(image)
            },
            onDisposed: {
                print("Finished choose photo memos.")
            }
        )
        
        //print("\(RxSwift.Resources.total)")
    }
    
}


extension ToDoDetailTableViewController {
    fileprivate func setMemoBtn(bkImage: UIImage) {
        // Todo: Set the background and title of add picture memo btn
        memoButton.setBackgroundImage(bkImage, for: .normal)
        memoButton.setTitle("", for: .normal)
    }
    
    fileprivate func resetMemoBtn() {
        // Todo: Set the background and title of add picture memo btn
        memoButton.setBackgroundImage(nil, for: .normal)
        memoButton.setTitle("Tap here to add your picture memos", for: .normal)
    }
}
