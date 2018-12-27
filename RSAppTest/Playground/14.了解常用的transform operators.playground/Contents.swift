import UIKit
import RxSwift

// toArray

let bag = DisposeBag()
Observable.of(1, 2, 3)
    .toArray()
    .subscribe(onNext: {
        dump(type(of: $0))
        dump($0)
    }).disposed(by: bag)
