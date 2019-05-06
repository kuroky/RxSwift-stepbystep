//
//  GeolocationService.swift
//  RxExample
//
//  Created by kuroky on 2019/4/22.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

// (Driver)
// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/driver.html
class GeolocationService {
    
    static let instance = GeolocationService()
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    private let locationManager = CLLocationManager()
    
    private init() {
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return true
                case .authorizedWhenInUse:
                    return true
                default:
                    return false
                }
        }
        
        location = locationManager.rx.didUpdateLocations.asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
        }
            .map { $0.coordinate }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}
