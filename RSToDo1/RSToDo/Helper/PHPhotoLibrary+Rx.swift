//
//  PHPhotoLibrary+Rx.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/27.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
    static var isAuthorized: Observable<Bool> {
        return Observable.create{ observer in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted() // 已同意
                }
                else {
                    observer.onNext(false) // 不同意
                    requestAuthorization { // 请求同意
                        observer.onNext( $0 == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}
