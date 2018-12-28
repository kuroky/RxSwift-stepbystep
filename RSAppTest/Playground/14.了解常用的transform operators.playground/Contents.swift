import UIKit
import RxSwift

// toArray 将事件转成array
func toArray() {
    print("\(#function) begin")
    let bag = DisposeBag()
    Observable.of(1, 2, 3)
        .toArray()
        .subscribe(onNext: {
            print(type(of: $0))
            print($0)
        }).disposed(by: bag)
    print("\(#function) end \n")
}
toArray()

// onComplete 结束才会发生转换
func toArray1() {
    print("\(#function) begin")
    let numbers = PublishSubject<Int>()
    let bag = DisposeBag()
    
    numbers.asObservable().toArray().subscribe(onNext: {
        print($0)
    }).disposed(by: bag)
    
    numbers.onNext(1)
    numbers.onNext(2)
    numbers.onCompleted()
    print("\(#function) end \n")
}
toArray1()

// scan
func scan() {
    print("\(#function) begin")
    let numbers = PublishSubject<Int>()
    let bag = DisposeBag()
    
    numbers.asObservable().scan(0) {
        accumulatedValue, value in
        accumulatedValue + value
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
    
    numbers.onNext(1)
    numbers.onNext(2)
    numbers.onNext(3)
    numbers.onNext(4)
    numbers.onCompleted()
    print("\(#function) end \n")
}
scan()

// map
func map() {
    print("\(#function) begin")
    let bag = DisposeBag()
    Observable.of(1, 2, 3).map { value in
        value * 2
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
    print("\(#function) end \n")
}
map()

// takeWhileWithIndex
func takeWhileWithIndex() {
    let bag = DisposeBag()
    print("\(#function) begin")
    Observable.of(1, 2, 3).enumerated().map {
        index, value in
        index < 1 ? value * 2 : value
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
    print("\(#function) end \n")
}
takeWhileWithIndex()
