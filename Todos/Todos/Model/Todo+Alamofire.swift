//
//  Todo+Alamofire.swift
//  Todos
//
//  Created by kuroky on 2018/12/28.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum GetTodoListError: Error {
    case cannotConverServerResponse
}

extension Todo {
    
    class func getList(from router: TodoRouter) -> Observable<[[String: Any]]> {
        return Observable.create{ (observer) -> Disposable in
            let request = Alamofire.request(router).responseJSON{ response in
                guard response.result.error == nil else {
                    return observer.onError(response.result.error!)
                }
                
                guard let todos = response.result.value as? [[String: Any]] else {
                    return observer.onError(GetTodoListError.cannotConverServerResponse)
                }
                
                observer.onNext(todos)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    
}

