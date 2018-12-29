import UIKit
import RxSwift

func delay(_ delay: Double, closure: @escaping () -> Void ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

func stamp() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let result = formatter.string(from: date)
    
    return result
}

// 订阅时，回放指定个数的事件 replayAll 可以回放所有事件
func replay() {
    // 最多回放2个事件
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(2)
    
    _ = interval.subscribe(onNext: {
        print("Subscribe1: Event - \($0) at \(stamp())")
    })
    _ = interval.connect()
    
    print("start - " + stamp())
    
    delay(2) {
        _ = interval.subscribe(onNext: {
            print("Subscribe2: Event - \($0) at \(stamp())")
        })
    }
    
    delay(4) {
        _ = interval.subscribe(onNext: {
            print("Subscribe3: Event - \($0) at \(stamp())")
        })
    }
}
//replay()

// 为事件的回放指定缓冲区
func buffer() {
    // timeSpan 时间跨度 count 最大事件数
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).buffer(timeSpan: 4, count: 2, scheduler: MainScheduler.instance)
    
    print("START - " + stamp())

    _ = interval.subscribe(onNext: {
        print("Subscriber 1: Event - \($0) at \(stamp())") })
}
//buffer()

func window() {
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).window(timeSpan: 4, count: 4, scheduler: MainScheduler.instance)
    
    print("START - " + stamp())
    
    _ = interval.subscribe(onNext: { (subObservable: Observable<Int>) in
        print("============= Window Open ===============")
        _ = subObservable.subscribe(onNext: {
            (value: Int) in
            print("Subscriber 1: Event - \(value) at \(stamp())")
        }, onCompleted: {
            print("============ Window Closed ==============")
        })
    })
}
window()

