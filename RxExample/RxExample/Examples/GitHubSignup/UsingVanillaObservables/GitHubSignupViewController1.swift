//
//  GitHubSignupViewController1.swift
//  RxExample
//
//  Created by kuroky on 2019/4/22.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GitHubSignupViewController1: UIViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOutlet: UIActivityIndicatorView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GithubSignupViewModel1(
            input: (
                username: usernameOutlet.rx.text.orEmpty.asObservable(),
                password: passwordOutlet.rx.text.orEmpty.asObservable(),
                repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asObservable(),
                loginTaps: signupOutlet.rx.tap.asObservable()
            ),
            dependency:(
                API: GitHubDefaultAPI.sharedAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )
        
        // bind results to
        viewModel.signupEabled
            .subscribe(onNext: { [weak self] valid in
                self?.signupOutlet.isEnabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            })
        .disposed(by: bag)
        
        viewModel.validatedUsername
        .bind(to: usernameValidationOutlet.rx.validationResult)
        .disposed(by: bag)
        
        viewModel.validatedPassword
        .bind(to: passwordValidationOutlet.rx.validationResult)
        .disposed(by: bag)
        
        viewModel.validatedPasswordRepeated
            .bind(to: repeatedPasswordValidationOutlet.rx.validationResult)
            .disposed(by: bag)
        
        viewModel.signingIn
            .bind(to: signingUpOutlet.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.signingIn
            .subscribe(onNext: { signedIn in
            print("User signed inn \(signedIn)")
        })
        .disposed(by: bag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: bag)
        view.addGestureRecognizer(tapBackground)
    }
}
