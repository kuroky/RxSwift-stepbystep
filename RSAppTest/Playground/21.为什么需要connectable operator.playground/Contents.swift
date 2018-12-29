import UIKit
import RxSwift

// 延迟1s执行
func delay(_ delay: Double, closure: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

// 使用publish发布事件
func publish() {
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
    
    // 使用publish，Subscribe1 和 Subscribe2共享同一个Observable
    _ = interval.subscribe(onNext: {
        print("Subscriber 1: \($0)")
    })
    
    _ = interval.connect() // 启动
    
    delay(2) {
        _ = interval.subscribe(onNext: {
            print("Subscriber 2: \($0)")
        })
    }
}
//publish()

// 使用multicast operator
func multicast() {
    let supervisor = PublishSubject<Int>()
    
    let intarval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(supervisor)
    
    
    
    _ = supervisor.subscribe(onNext: {
        print("Supervisor: event \($0)")
    })
    
    _ = intarval.subscribe(onNext: {
        print("Subscribe1: \($0)")
    })
    
    delay(2) {
        _ = intarval.subscribe(onNext: {
            print("Subscribe2: \($0)")
        })
    }
    
    delay(4) {
        _ = intarval.subscribe(onNext: {
            print("Subscribe3: \($0)")
        })
    }
    
    delay(6) {
        _ = intarval.subscribe(onNext: {
            print("Subscribe4: \($0)")
        })
    }
    
    intarval.connect()
}
multicast()
