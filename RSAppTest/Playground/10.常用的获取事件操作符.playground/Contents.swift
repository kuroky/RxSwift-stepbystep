import UIKit
import RxSwift

// index
func example() {
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
example()

// filter
func example1() {
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
example1()

// take 前两个事件
func example2() {
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
example2()

// takeWhile/enumerated().takeWhile
func example3() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.takeWhile{ $0 != "T3" }
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
example3()

func example4() {
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
example4()

// takeUntil
func example5() {
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
example5()

