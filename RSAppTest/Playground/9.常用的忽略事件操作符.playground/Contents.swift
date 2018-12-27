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
func ignore() {
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
ignore()

// skip
func skip() {
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
skip()

// skipWhile/skipUntil
func skipWhile() {
    let tasks = PublishSubject<Bool>()
    let bag = DisposeBag()
    
    tasks.skipWhile {
            $0 == false // 跳过头几个元素 直到表达式为否
        }
        .subscribe{ print($0) }
        .disposed(by: bag)
    
    print("\(#function) begin")
    tasks.onNext(false)
    tasks.onNext(true)
    tasks.onNext(false)
    tasks.onCompleted()
    print("\(#function) end \n")
}
skipWhile()

func skipUntil() {
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
skipUntil()

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
