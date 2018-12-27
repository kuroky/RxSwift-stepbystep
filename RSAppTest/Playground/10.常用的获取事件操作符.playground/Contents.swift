import UIKit
import RxSwift

// index
func elementAt() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.elementAt(1)
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
elementAt()

// filter
func filter() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.filter{ $0 == "T1" }
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
filter()

// take 前两个事件
func take() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.take(2)
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
take()

// takeWhile/enumerated().takeWhile
func takeWhile() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.takeWhile{ $0 != "T1" } 
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
takeWhile()

func enumerated() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.enumerated().takeWhile { (index, value) in
            value != "T3" && index < 3
        }
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
enumerated()

// takeUntil
func takeUntil() {
    let tasks = PublishSubject<String>()
    let bossHasGone = PublishSubject<Void>()
    let bag = DisposeBag()
    
    tasks.takeUntil(bossHasGone)
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    bossHasGone.onNext(())
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
takeUntil()

