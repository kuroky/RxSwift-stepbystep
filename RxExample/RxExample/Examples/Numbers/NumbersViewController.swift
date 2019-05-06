//
//  NumbersViewController.swift
//  RxExample
//
//  Created by kuroky on 2019/4/19.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/decision_tree/combineLatest.html

class NumbersViewController: UIViewController {

    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue3) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
