//
//  ViewController.swift
//  DisposableDemo
//
//  Created by Mars on 5/20/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var interval: Observable<Int>!
    var subscription: Disposable!
    var bag: DisposeBag! = DisposeBag()

    @IBOutlet weak var counter: UITextField!
    @IBOutlet weak var disposeCounter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.interval = Observable.interval(0.5, scheduler: MainScheduler.instance)
        self.interval.map { return String($0) }
            .subscribe(onNext: { self.counter.text = $0 })
            .disposed(by: self.bag)
        //self.subscription.disposed(by: self.bag)
        
        self.disposeCounter.rx.tap.subscribe(onNext: {
            print("dispose interval")
            //self.bag = nil
        }).disposed(by: self.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

