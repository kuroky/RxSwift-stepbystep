import UIKit
import RxSwift

enum Condition: String {
    case cellular = "Cellular"
    case wifi = "WiFi"
    case none = "none"
}

// startWith
func startWith() {
    print("\(#function) begin")
    let bag = DisposeBag()
    let request = Observable<String>.create { observer in
        observer.onNext("Response from server")
        observer.onCompleted()
        return Disposables.create()
    }
    
    request.startWith(Condition.wifi.rawValue).subscribe(onNext: {
        print($0)
    }).disposed(by: bag)
    print("\(#function) end \n")
}
startWith()

// 串行合并多个事件序列
func concat() {
    print("\(#function) begin")
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<String>()
    let bag = DisposeBag()
    
//    _ = Observable.concat([queueA.asObserver(), queueB.asObserver()]).subscribe(onNext: {
//            print($0)
//    }).disposed(by: bag)
    
    queueA.concat(queueB.asObserver())
        .subscribe(onNext: {
            print($0)
        },
        onCompleted: {
            print("onCompleted")
        },
        onDisposed: {
            print("onDisposed")
        }
        ).disposed(by: bag)
    
    queueA.onNext("A1")
    queueA.onNext("A2")
    queueA.onNext("A3")
    //queueA.onCompleted()
    queueB.onNext("B1")
    //queueB.onCompleted()
    print("\(#function) end \n")
    
    queueA.concat(queueB.asObserver()).subscribe(onNext: {
        print($0)
    })
}
concat()

// 并行合并多个事件序列
func merge() {
    print("\(#function) begin")
    
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<String>()
    
    _ = Observable.merge([queueA.asObserver(), queueB.asObserver()]).subscribe(onNext: {
        print($0)
    }, onCompleted: {
        print("onCompleted")
    }, onDisposed: {
        print("onDisposed")
    })
    
    queueA.onNext("A1")
    queueA.onNext("A2")
    queueB.onNext("B1")
    queueA.onNext("A3")
    queueA.onCompleted()
    queueB.onCompleted()
    
    print("\(#function) end \n")
}
merge()

// 控制最大订阅量
func control() {
    print("\(#function) begin")
    
    let queueA = PublishSubject<String>()
    let queueB = PublishSubject<String>()
    
    _ = Observable.of(queueB.asObserver(), queueA.asObserver()).merge(maxConcurrent: 1).subscribe(onNext: {
        print($0)
    }, onCompleted: {
        print("onCompleted")
    }, onDisposed: {
        print("onDisposed")
    })
    
    queueA.onNext("A1")
    queueA.onNext("A2")
    queueB.onNext("B1")
    queueA.onNext("A3")
    queueA.onCompleted()
    queueB.onCompleted()
    
    print("\(#function) end \n")
}
control()
