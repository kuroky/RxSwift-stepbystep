//
//  GitHubSignupViewModel2.swift
//  RxExample
//
//  Created by kuroky on 2019/4/23.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import RxSwift
import RxCocoa

class GithubSignupViewModel2 {
    // outputs
    
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    // Is signup button enabled
    let signupEnabled: Driver<Bool>
    
    // Has user signed in
    let signedIn: Driver<Bool>
    
    // Is signing process in progress
    let signingIn: Driver<Bool>
    
    init(
        input: (
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Signal<()>
        ),
        dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: Wireframe
        )
        ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        /**
        Notice how np subscribe call is being made.
         Everything is just a definition.
         
         Pure transformtion of input sequences to out sequences.
         
         When using `Driver` underlying observable sequence elements are shared because
         driver automagically adds "shareReplay(1)" under the hood.
         
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(.Failed(message: "Error contactinng server"))
         
         ... are squashed into single `.asDriver(onErrorJustReturn: .Failed(message: "Error contacting server"))`
         */
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
        }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (username: $0, password: $1)}
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
        }
            .flatMapLatest { loggedIn -> Driver<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                .map { _ in
                    loggedIn
                }
                .asDriver(onErrorJustReturn: false)
        }
        
        signupEnabled = Driver.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn
            ) { username, password, repeatPassword, signingIn in
                username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
        }
        .distinctUntilChanged()
    }
}
