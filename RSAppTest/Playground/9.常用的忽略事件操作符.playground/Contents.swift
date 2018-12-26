import UIKit
import RxSwift

func example() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
example()

// ignore
func example1() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.ignoreElements()
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

// skip
func example2() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.skip(2)
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

// skipWhile/skipUntil
func example3() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.skipWhile {
            $0 != "T2"
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
example3()

func example4() {
    let tasks = PublishSubject<String>()
    let bossIsAnary = PublishSubject<Void>()
    let bag = DisposeBag()
    
    tasks.skipUntil(bossIsAnary)
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    bossIsAnary.onNext(())
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
example4()

// 忽略连续重复事件
func example5() {
    let tasks = PublishSubject<String>()
    let bag = DisposeBag()
    
    tasks.distinctUntilChanged()
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext("T1")
    tasks.onNext("T2")
    tasks.onNext("T2")
    tasks.onNext("T3")
    tasks.onCompleted()
    print("\(#function) end \n")
}
example5()
