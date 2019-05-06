//
//  SimpleTableViewExampleViewController.swift
//  RxExample
//
//  Created by kuroky on 2019/4/23.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: bag)
        
        tableView.rx
        .modelSelected(String.self)
            .subscribe(onNext: { value in
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: bag)
        
        tableView.rx.itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
            DefaultWireframe.presentAlert("Tapped Detail !\(indexPath.section), \(indexPath.row)")
        })
            .disposed(by: bag)
    }
}
