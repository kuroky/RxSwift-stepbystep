//
//  GeolocationViewController.swift
//  RxExample
//
//  Created by kuroky on 2019/4/19.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

private extension Reactive where Base: UILabel {
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude) \nLon: \(location.longitude)"
        }
    }
}

class GeolocationViewController: UIViewController {

    
    @IBOutlet weak var noGeolocationView: UIView!
    @IBOutlet weak var openBtn1: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openBtn2: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noGeolocationView.frame = view.bounds
        view.addSubview(noGeolocationView)
        
        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized
            .drive(noGeolocationView.rx.isHidden)
            .disposed(by: bag)
        
        geolocationService.location
            .drive(locationLabel.rx.coordinates)
            .disposed(by: bag)
        
        openBtn1.rx.tap
            .bind { [weak self] in
                self?.openAppPreferences()
        }
            .disposed(by: bag)
        
        openBtn2.rx.tap
            .bind { [weak self] in
                self?.openAppPreferences()
        }
            .disposed(by: bag)
    }

    func openAppPreferences() {
        let url = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
