//
//  GithubSignupViewModel1.swift
//  RxExample
//
//  Created by kuroky on 2019/4/22.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import RxSwift
import RxCocoa

class GithubSignupViewModel1 {
    // inputs
    
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    // is signup button enabled
    let signupEabled: Observable<Bool>
    
    // has user signed in
    let signedIn: Observable<Bool>
    
    // is signing process in progress
    let signingIn: Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        loginTaps: Observable<Void>
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
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            }
            .share(replay: 1)
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .share(replay: 1)
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) {
            (username: $0, password: $1)
        }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
                    .trackActivity(signingIn)
            }
            .flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in
                        loggedIn
                }
            }
            .share(replay: 1)
        
        signupEabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn.asObservable()
        ) { username, password, repeatPassword, signingIn in
            username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
            .share(replay: 1)
    }
}
