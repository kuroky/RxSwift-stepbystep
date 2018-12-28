import UIKit
import RxSwift

// 多个Observables中的事件合并为一个 combineLatest 最多可传7个
func combineLatest() {
    print("\(#function) begin")
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<String>()
    
    Observable.combineLatest(queueA, queueB) {
        eventA, eventB in
        eventA + "," + eventB
        }.subscribe(onNext: {
            print($0)
        })
    
    queueA.onNext("a1")
    queueA.onNext("a2")
    queueB.onNext("b1")
    queueB.onNext("b2")
    print("\(#function) end \n")
}
combineLatest()

// 合并事件类型不同的Sub-obervables
func combineLatest1() {
    print("\(#function) begin")
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<Int>()
    
    Observable.combineLatest(queueA, queueB) {
        eventA, eventB in
        eventA + "," + String(eventB)
        }.subscribe(onNext: {
            print($0)
        })
    
    queueA.onNext("a1")
    queueA.onNext("a2")
    queueB.onNext(1)
    queueB.onNext(2)
    print("\(#function) end \n")
}
combineLatest1()

// 真正只合并最新事件的operator
func zip() {
    print("\(#function) begin")
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<Int>()
    
    Observable.zip(queueA, queueB) {
        eventA, eventB in
        eventA + "," + String(eventB)
        }.subscribe(onNext: {
            print($0)
        })

    queueA.onNext("A1")
    queueB.onNext(1)
    queueA.onNext("A2")
    queueB.onNext(2)
    queueB.onNext(3)
    
    print("\(#function) end \n")
}
zip()
