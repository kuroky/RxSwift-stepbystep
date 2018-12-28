import UIKit
import RxSwift

let textField = BehaviorSubject<String>(value: "boxu")
let submitBtn = PublishSubject<Void>()

submitBtn.withLatestFrom(textField)
    .subscribe(onNext: { print($0) })

submitBtn.onNext(())
textField.onNext("boxue")
submitBtn.onNext(())
print("\n")

let coding = PublishSubject<String>()
let testing = PublishSubject<String>()
let working = PublishSubject<Observable<String>>()

working.switchLatest().subscribe(onNext: {
    print($0)
})

working.onNext(coding)
coding.onNext("version1")

working.onNext(testing)
testing.onNext("fail")
coding.onNext("version2")

working.onNext(coding)
coding.onNext("version2")

working.onNext(testing)
testing.onNext("success")
