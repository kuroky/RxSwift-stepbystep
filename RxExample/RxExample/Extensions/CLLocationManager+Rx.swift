//
//  CLLocationManager+Rx.swift
//  RxExample
//
//  Created by kuroky on 2019/4/22.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

extension Reactive where Base: CLLocationManager {
    
    public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    //MARK:- Responding to Location Events
    public var didUpdateLocations: Observable<[CLLocation]> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocationsSubject.asObserver()
    }
    
    public var didFailWithError: Observable<Error> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObserver()
    }
    
    public var didFinishDeferredUpdatesWithError: Observable<Error?> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)))
            .map { a in
                return try castOptionalOrThrow(Error.self, a[1])
        }
    }
    
    //MARK:- Pausing Location Updates
    public var didPauseLocationUpdates: Observable<Void> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidPauseLocationUpdates(_:)))
            .map {_ in
                return ()
        }
    }
    
    public var didResumeLocationUpdate: Observable<Void> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidResumeLocationUpdates(_:)))
            .map { _ in
                return ()
        }
    }
    
    //MARK:- Responding to Headinng Events
    public var didUpdateHeading: Observable<CLHeading> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateHeading:)))
            .map { a in
                return try castOrThorw(CLHeading.self, a[1])
        }
    }
    
    //MARK:- Responding to Region Events
    public var didEnterRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didEnterRegion:)))
            .map { a in
                return try castOrThorw(CLRegion.self, [1])
        }
    }
    
    public var didExitRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didExitRegion:)))
            .map { a in
                return try castOrThorw(CLRegion.self, a[1])
        }
    }
    
    public var didDeterminStateForRegion: Observable<(state: CLRegionState, region: CLRegion)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didDetermineState:for:)))
            .map { a in
                let stateNumber = try castOrThorw(NSNumber.self, a[1])
                let state = CLRegionState(rawValue: stateNumber.intValue) ?? CLRegionState.unknown
                let region = try castOrThorw(CLRegion.self, a[2])
                return (state: state, region: region)
        }
    }
    
    public var monitoringDidFailForRegionWithError: Observable<(region: CLRegion?, error: Error)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:monitoringDidFailFor:withError:)))
            .map { a in
                let region = try castOptionalOrThrow(CLRegion.self, a[1])
                let error = try castOrThorw(Error.self, a[2])
                return (region: region, error: error)
        }
    }
    
    public var didStartMonitoringForRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didStartMonitoringFor:)))
            .map { a in
                return try castOrThorw(CLRegion.self, a[1])
        }
    }
    
    //MARK:- Responding to Ranging Events
    public var didRangeBeaconsInRegion: Observable<(beacons: [CLBeacon], region: CLBeaconRegion)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didRangeBeacons:in:)))
            .map { a in
                let beacons = try castOrThorw([CLBeacon].self, a[1])
                let region = try castOrThorw(CLBeaconRegion.self, a[2])
                return (beacons: beacons, region: region)
        }
    }
    
    public var rangingBeaconnsDidFailForRegionWithError: Observable<(region: CLBeaconRegion, error: Error)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:rangingBeaconsDidFailFor:withError:)))
            .map {a in
                let region = try castOrThorw(CLBeaconRegion.self, a[1])
                let error = try castOrThorw(Error.self, a[2])
                return (region: region, error: error)
        }
    }
    
    public var didVisit: Observable<CLVisit> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didVisit:)))
            .map { a in
                return try castOrThorw(CLVisit.self, a[1])
        }
    }
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { a in
                let number = try castOrThorw(NSNumber.self, a[1])
                return CLAuthorizationStatus(rawValue: Int32(number.intValue)) ?? .notDetermined
        }
    }
}

fileprivate func castOrThorw<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
