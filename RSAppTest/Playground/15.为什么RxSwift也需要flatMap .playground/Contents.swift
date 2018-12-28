import UIKit
import RxSwift
import RxCocoa

struct Player {
    var score: BehaviorRelay<String>
}

let John = Player(score: BehaviorRelay(value: "john init"))
let Jole = Player(score: BehaviorRelay(value: "jole init"))

let players = PublishSubject<Player>()

let bag = DisposeBag()
players.asObservable().flatMap{
        $0.score.asObservable()
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: bag)

players.onNext(John) // john init

John.score.accept("john value1")
players.onNext(Jole) // jole init
John.score.accept("john value2")
Jole.score.accept("jole value1")
print("\n")

let John1 = Player(score: BehaviorRelay(value: "john1 init"))
let Jole1 = Player(score: BehaviorRelay(value: "jole1 init"))
let players1 = PublishSubject<Player>()
players1.asObservable().flatMapLatest{
    $0.score.asObservable()
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: bag)

players1.onNext(John1) // john1 init

John1.score.accept("john1 value1")
players1.onNext(Jole1) // jole1 init
John1.score.accept("john1 value2")

Jole1.score.accept("jole1 value1")


