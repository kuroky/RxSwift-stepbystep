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
        return todoSubject.asObservable()
    }
    var bag = DisposeBag()
    
    var todoItem: TodoItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!
    
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
        nameTextField.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(clickCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(clickConfirm))
        self.navigationItem.rightBarButtonItem?.isEnabled = todoItem.name.count > 0
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
        
        let selectedPhotos = photoVC.selectedPhotos.share()
        _ = selectedPhotos.scan([]) {
            (photos: [UIImage], newPhoto: UIImage) in
            var newPhotos = photos
            
            if let index = newPhotos.index(where: { UIImage.isEqual(lhs: newPhoto, rhs: $0) }) {
                newPhotos.remove(at: index)
            }
            else {
                newPhotos.append(newPhoto)
            }
            return newPhotos
            
            }.subscribe(
                onNext: { images in
                    self.images.value = images
            },
                onDisposed: {
                    print("Finished choose photo memos.")
            }).disposed(by: photoVC.bag)
        
        _ = selectedPhotos.ignoreElements().subscribe( onCompleted: {
            self.setMemoSectionText()
        }).disposed(by: photoVC.bag)
        //print("\(RxSwift.Resources.total)")
    }
}

extension ToDoDetailTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        self.navigationItem.rightBarButtonItem?.isEnabled = newText.length > 0
        return true
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
    
    fileprivate func setMemoSectionText() {
        guard !images.value.isEmpty else { return }
        self.memoLabel.text = "\(images.value.count) MEMOS"
    }
}
