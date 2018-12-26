import UIKit
import RxSwift

//PublishSubject
func publishSubject() {
    let subject = PublishSubject<String>() // 创建
    
    let sub1 = subject.subscribe(onNext: { // 订阅
        print("PublishSubject: Sub1 - what happend: \($0)")
    })
    
    subject.onNext("Epiode1 updated") // 发送消息
    sub1.dispose() // 取消订阅
    
    let sub2 = subject.subscribe(onNext: { // 订阅
        print("PublishSubject: Sub2 - waht happend: \($0)")
    })
    
    subject.onNext("Epiode2 updated") // 发送消息
    subject.onNext("Epiode3 updated") // 发送消息
    sub2.dispose() // 取消订阅
}
publishSubject()
print("\n")

func behaviorSubject() {
    // 创建并设置默认值
    let subject = BehaviorSubject<String>(value: "RxSwift step by step")
    
    let sub1 = subject.subscribe(onNext: { // 订阅
        print("BehaviorSubject: Sub1 - what happend: \($0)")
    })
    
    subject.onNext("Epiode1 updated") // 发送消息
    sub1.dispose() // 取消订阅
    
    let sub2 = subject.subscribe(onNext: { // 订阅
        print("BehaviorSubject: Sub2 - waht happend: \($0)")
    })
    
    subject.onNext("Epiode2 updated") // 发送消息
    subject.onNext("Epiode3 updated") // 发送消息
    sub2.dispose() // 取消订阅
}
behaviorSubject()
print("\n")

//ReplaySubject
func replaySubject() {
    // 创建并设置 :bufferSize 最多接受订阅前的消息数
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    
    let sub1 = subject.subscribe(onNext: { // 订阅
        print("ReplaySubject: Sub1 - what happend: \($0)")
    })
    
    subject.onNext("Epiode1 updated") // 取消订阅
    subject.onNext("Epiode2 updated") // 取消订阅
    subject.onNext("Epiode3 updated") // 取消订阅
    sub1.dispose() // 取消订阅
    
    let sub2 = subject.subscribe(onNext: { // 订阅
        print("ReplaySubject: Sub2 - waht happend: \($0)")
    })
    sub2.dispose() // 取消订阅
}
replaySubject()
print("\n")



