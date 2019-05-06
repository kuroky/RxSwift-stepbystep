//
//  ViewController.swift
//  RxExample
//
//  Created by kuroky on 2019/4/19.
//  Copyright © 2019 Emucoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellIdentifer   =   "cellIdentifer"
    var tableView: UITableView!
    let  items: [[(title: String, desc: String)]] = [[
        (title: "Adding numbers", desc: "Bindings"),
        (title: "Simple validation", desc: "Bindings"),
        (title: "Geolocation Subscription", desc: "Observers, service and Drive example"),
        (title: "GitHub Signup - Vanilla Observables", desc: "Simple MVVM example"),
        (title: "GitHub Signup - Using Driver", desc: "Simple MVVM example"),
        (title: "API wrappers", desc: "API wrappers example"),
        (title: "Calculator", desc: "Stateless calculator example"),
        (title: "ImagePicker", desc: "UIImagePickerController example"),
        (title: "UIPickerView", desc: "UIPickerView example")],
        
                              [
        (title: "Simplest table view example", desc: "Basic"),
        (title: "Simplest table view example with sections", desc: "Basic"),
        (title: "TableView with editing|Model editing using observable sequences, master", desc: "detail"),
        (title: "Table/CollectionView partial updates", desc: "Table and Collection view with partial updates")],
        
                              [
        (title: "Search Wikipedia", desc: "Complex async, activity indicator"),
        (title: "GitHub Search Repositories", desc: "Paging, activity indicator")
                               ]]
    
    let sbDics: [String: (sbName: String, clsName: String)] = [
        "Adding numbers": (sbName: "Numbers", clsName: "NumbersViewController"),
        "Simple validation": (sbName: "SimpleValidation", clsName: "NumbersViewController"),
        "Geolocation Subscription": (sbName: "Geolocation", clsName: "NumbersViewController"),
        "GitHub Signup - Vanilla Observables": (sbName: "GitHubSignup1", clsName: "GitHubSignupViewController1"),
        "GitHub Signup - Using Driver": (sbName: "GitHubSignup2", clsName: "GitHubSignupViewController2"),
        "API wrappers": (sbName: "", clsName: ""),
        "Calculator": (sbName: "", clsName: ""),
        "ImagePicker": (sbName: "", clsName: ""),
        "UIPickerView": (sbName: "", clsName: ""),
        "Simplest table view example": (sbName: "SimpleTableViewExample", clsName: "SimpleTableViewExampleViewController"),
        "Simplest table view example with sections": (sbName: "", clsName: ""),
        "TableView with editing": (sbName: "", clsName: ""),
        "Table/CollectionView partial updates": (sbName: "", clsName: ""),
        "Search Wikipedia": (sbName: "", clsName: ""),
        "GitHub Search Repositories": (sbName: "", clsName: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestForLocation()
    }

    func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "RxSwift"
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
    }

    
    func requestForLocation() {
        let geoService = GeolocationService.instance
        geoService.authorized.drive(onNext: { _ in
            
        }).dispose()
        
        geoService.location.drive(onNext: { _ in
            
        }).dispose()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subItems = items[section]
        return subItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellIdentifer)
        let subItems: [(title: String, desc: String)] = items[indexPath.section]
        let item: (title: String, desc: String) = subItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.text = item.desc
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let para = parserNameAtIndex(indexPath)
        
        if para.sbName == nil || para.cls == nil {
            print("no file")
            return
        }
        
        let vc = try! UIViewController.loadFromStoryboard(sbName: para.sbName!, type: para.cls!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parserNameAtIndex(_ indexPath: IndexPath) -> (sbName: String?, cls: UIViewController.Type?) {
        let subItems: [(title: String, desc: String)] = items[indexPath.section]
        let item: (title: String, desc: String) = subItems[indexPath.row]
        guard let para = sbDics[item.title] else {
            return (sbName: nil, cls: nil)
        }
        
        if para.sbName.isEmpty || para.clsName.isEmpty {
            return (sbName: nil, cls: nil)
        }
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        let cls: UIViewController.Type = NSClassFromString("\(namespace).\(para.clsName)")! as! UIViewController.Type
        
        return (sbName: para.sbName, cls: cls)
    }
}
