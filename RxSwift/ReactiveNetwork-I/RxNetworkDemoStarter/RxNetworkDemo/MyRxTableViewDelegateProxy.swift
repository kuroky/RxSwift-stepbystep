//
//  MyRxTableViewDelegateProxy.swift
//  RxNetworkDemo
//
//  Created by kuroky on 2019/5/9.
//  Copyright © 2019 Boxue. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MyRxTableViewDelegateProxy: DelegateProxy<UITableView, UITableViewDelegate>, UITableViewDelegate, DelegateProxyType {
    
    init(tableView: UITableView) {
        super.init(parentObject: tableView, delegateProxy: MyRxTableViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { MyRxTableViewDelegateProxy(tableView: $0) }
    }

    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
        object.delegate = delegate
    }
    
    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
        return object.delegate
    }
}

private extension Selector {
    static let didSelectRowAtIndexPath = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
}

extension UITableView {
    var rxDelegate: MyRxTableViewDelegateProxy {
        return MyRxTableViewDelegateProxy.proxy(for: self)
    }
    
    var rxDidSelectRowAtIndexPath: Observable<(UITableView, IndexPath)> {
        return rxDelegate.methodInvoked(.didSelectRowAtIndexPath).map({ items -> (UITableView, IndexPath) in
            return (items.first as! UITableView, items.last as! IndexPath)
        })
    }
    
    var rxViewForHeader: Observable<(UITableView, IndexPath)> {
        return rxDelegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))).map({ items -> (UITableView, IndexPath) in
            return (items.first as! UITableView, items.last as! IndexPath)
        })
    }
    
}
