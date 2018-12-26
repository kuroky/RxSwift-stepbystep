import UIKit
import RxSwift

enum CustomError: Error {
    case somethingError
}

// create
let customOb = Observable<Int>.create { observer in
    // next event
    observer.onNext(10)
    observer.onNext(11)
    
    // error event
    observer.onError(CustomError.somethingError)
    
    // complete event
    observer.onCompleted()
    return Disposables.create()
}

let disposeBag = DisposeBag()

customOb.debug()
    .subscribe(
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("onComplete") },
    onDisposed: { print("Game over") }
).disposed(by: disposeBag)
