//
//  GitHubSignupViewController2.swift
//  RxExample
//
//  Created by kuroky on 2019/4/23.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GitHubSignupViewController2: UIViewController {

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
        
        let viewModel = GithubSignupViewModel2(
            input: (username: usernameOutlet.rx.text.orEmpty.asDriver(),
                    password: passwordOutlet.rx.text.orEmpty.asDriver(),
                    repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
                    loginTaps: signupOutlet.rx.tap.asSignal()),
            dependency: (API: GitHubDefaultAPI.sharedAPI,
                         validationService: GitHubDefaultValidationService.sharedValidationService,
                         wireframe: DefaultWireframe.shared)
        )
        
        // bind results to
        viewModel.signupEnabled
            .drive(onNext: { [weak self] valid in
                self?.signupOutlet.isEnabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5;
            })
        .disposed(by: bag)
        
        viewModel.validatedUsername
        .drive(usernameValidationOutlet.rx.validationResult)
        .disposed(by: bag)
        
        viewModel.validatedPassword
            .drive(passwordValidationOutlet.rx.validationResult)
            .disposed(by: bag)
        
        viewModel.validatedPasswordRepeated
        .drive(repeatedPasswordValidationOutlet.rx.validationResult)
        .disposed(by: bag)
        
        viewModel.signingIn
        .drive(signingUpOutlet.rx.isAnimating)
        .disposed(by: bag)
        
        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
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
