//
//  ViewController.swift
//  ReactiveLogin
//
//  Created by Mars on 5/21/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var register: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        
        let emialObservable = email.rx.text.map { (text: String!) -> Bool in
            if text.count > 0 {
                return true
            }
            return false
        }
        
        emialObservable.map { valid -> UIColor in
            if valid {
                return UIColor.green
            }
            return UIColor.clear
            }.subscribe(onNext: { (color: UIColor) in
                self.email.layer.borderColor = color.cgColor
            }).disposed(by: bag)
        
        let passwordObservable = password.rx.text.map { (text: String!) -> Bool in
            if text.count > 0 {
                return true
            }
            return false
        }

        passwordObservable.map { vaild -> UIColor in
            if vaild {
                return UIColor.green
            }
            return UIColor.clear
            }.subscribe(onNext: { (color: UIColor) in
                self.password.layer.borderColor = color.cgColor
            }).disposed(by: bag)
        
        Observable.combineLatest(emialObservable, passwordObservable) { (emailValid: Bool, passwordValid: Bool) -> [Bool] in
            return [emailValid, passwordValid]
            }
            .map { (valids: [Bool]) -> Bool in
                return valids.reduce(true, { (valid1, valid2) -> Bool in
                    valid1 && valid2
                })
            }
            .subscribe(onNext: { (valid: Bool) in
                self.register.isEnabled = valid
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

