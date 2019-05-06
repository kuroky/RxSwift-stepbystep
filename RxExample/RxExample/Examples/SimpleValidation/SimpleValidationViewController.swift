//
//  SimpleValidationViewController.swift
//  RxExample
//
//  Created by kuroky on 2019/4/19.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minUsernameLength   =   5
fileprivate let minPasswordLength   =   5

// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/decision_tree/shareReplay.html

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameValid: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordValid: UILabel!
    
    @IBOutlet weak var signBtn: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameValid.text = "Username has to be at least \(minUsernameLength) characters"
        passwordValid.text = "Username has to be at least \(minPasswordLength) characters"
        
        let usernameV = usernameTF.rx.text.orEmpty
            .map { $0.count >= minUsernameLength }
            .share(replay: 1)
        
        let passwordV = passwordTF.rx.text.orEmpty
            .map { $0.count >= minPasswordLength }
            .share(replay: 1)
        
        let everythValid = Observable.combineLatest(usernameV, passwordV) { $0 && $1 }
            .share(replay: 1)
        
        //usernameV
        //    .bind(to: passwordTF.rx.isEnabled)
        //    .disposed(by: bag)
        
        usernameV
            .bind(to: usernameValid.rx.isHidden)
            .disposed(by: bag)
        
        passwordV
            .bind(to: passwordValid.rx.isHidden)
            .disposed(by: bag)
        
        everythValid
            .bind(to: signBtn.rx.isEnabled)
            .disposed(by: bag)
        
        signBtn.rx.tap.subscribe(
            onNext: { [weak self] _ in
            self?.showAlert()
        }).disposed(by: bag)
    }
    
    func showAlert() {
        let alertView = UIAlertController.init(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }

}
