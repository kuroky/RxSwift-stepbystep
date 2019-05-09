//
//  AboutYouViewController.swift
//  ReactiveLogin
//
//  Created by Mars on 5/23/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum Gender {
    case notSelected
    case male
    case female
}

class AboutYouViewController: UIViewController {

    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var knowSwift: UISwitch!
    @IBOutlet weak var swiftLevel: UISlider!
    @IBOutlet weak var passionToLearn: UIStepper!
    @IBOutlet weak var heartHeight: NSLayoutConstraint!
    @IBOutlet weak var update: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.birthday.layer.borderWidth = 1
        
        let birthObservable = self.birthday.rx.date.map { (date) -> Bool in
            return InputValidator.isValidDate(date: date)
        }
        
        birthObservable.map { valid -> UIColor in
            return valid ? UIColor.green : UIColor.clear
            }
            .subscribe(onNext: {
                self.birthday.layer.borderColor = $0.cgColor
            })
            .disposed(by: self.bag)
        
        let genderSelection = Variable<Gender>(.notSelected)
        
        self.male.rx.tap.map { Void -> Gender in
            return Gender.male
        }
            .bind(to: genderSelection)
            .disposed(by: self.bag)
        
        self.female.rx.tap.map { Void -> Gender in
            return Gender.female
        }
            .bind(to: genderSelection)
            .disposed(by: self.bag)
        
        genderSelection.asObservable().subscribe(onNext: { (gender: Gender) in
            switch gender {
            case .male:
                self.male.setImage(UIImage.init(named: "check"), for: .normal)
                self.female.setImage(UIImage.init(named: "uncheck"), for: .normal)
            case .female:
                self.male.setImage(UIImage.init(named: "uncheck"), for: .normal)
                self.female.setImage(UIImage.init(named: "check"), for: .normal)
            default:
                break
            }
        }).disposed(by: self.bag)
        
        let genderObservable = genderSelection.asObservable().map { (gender: Gender) -> Bool in
            return gender == .notSelected ? false : true
        }
        
        Observable.combineLatest(birthObservable, genderObservable) { (birthValid: Bool, genderValid: Bool) -> [Bool] in
            return [birthValid, genderValid]
            }.map { (valids: [Bool]) -> Bool in
                return valids.reduce(true, { (valid1, valid2) -> Bool in
                    valid1 && valid2
                })
            }.subscribe(onNext: { (valid: Bool) in
                self.update.isEnabled = valid
            }).disposed(by: self.bag)
        
        
        self.knowSwift.rx.value.map { (on: Bool) -> Float in
            return on ? 0.25 : 0
        }
            .bind(to: self.swiftLevel.rx.value)
            .disposed(by: self.bag)
        
        self.swiftLevel.rx.value.map { (value: Float) -> Bool in
            return value >= 0.25 ? true : false
        }
            .bind(to: self.knowSwift.rx.value)
            .disposed(by: self.bag)
        
        self.passionToLearn.rx.value.map { (value: Double) -> Double in
            return value
            }
            .skip(1).subscribe(onNext: { [weak self] height in
                self?.heartHeight.constant = CGFloat(height)
            }).disposed(by: self.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
