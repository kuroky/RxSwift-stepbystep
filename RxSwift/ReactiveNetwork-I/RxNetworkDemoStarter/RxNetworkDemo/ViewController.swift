//
//  ViewController.swift
//  RxNetworkDemo
//
//  Created by Mars on 6/1/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var repositoryName: UITextField!
    @IBOutlet weak var searchResult: UITableView!
    
    typealias SectionTableModel = SectionModel<String, RepositoryModel>
    
    var bag: DisposeBag! = DisposeBag()
    
    var dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>(configureCell: { (_, tv, indexPath, element) in
        let cell = tv.dequeueReusableCell(withIdentifier: "RepositoryInfoCell", for: indexPath) as! RepositoryInfoCell
        cell.nameLabel.text = element.full_name
        cell.descLabel.text = element.description
        return cell
    })
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.searchResult.rowHeight = 80
        
        self.searchResult.rxDidSelectRowAtIndexPath.subscribe(onNext: { tbl, indexPath in
            tbl.deselectRow(at: indexPath, animated: true)
            
        }).disposed(by: self.bag)
        /*
        self.searchResult.rxViewForHeader.subscribe(onNext: { tableView, indexPath in
            let section = self.dataSource.numberOfSections(in: tableView)
            guard section != 0 else {
                return nil
            }
            
            let item = self.dataSource.sectionIndexTitles[indexPath.section]
            //let lable
        }).disposed(by: self.bag)
        */
        self.repositoryName.rx.text.filter { (text: String?) -> Bool in
            return text!.count > 2
            }
            .throttle(0.5, scheduler: MainScheduler.instance) // 忽略的时间间隔
            // flatMap 把映射前的事件(UITextField的输入) 和映射后的事件(网络请求) 合并成一个事件发送给订阅者
            .flatMap({ (search: String?) -> Observable<[RepositoryModel]> in
                self.searchForGithub(repositoryName: search)
            })
            .subscribe(onNext: { (ret: [RepositoryModel]) in
                self.searchResult.dataSource = nil
                print(ret.count)
                Observable.just(self.createGithubSectionModel(repoInfo: ret)).bind(to: self.searchResult.rx.items(dataSource: self.dataSource))
                    .disposed(by: self.bag)
                
            }, onError: { error in
                self.displayErrorAlert(error: error)
            })
            .disposed(by: self.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    private func searchForGithub(repositoryName: String?) -> Observable<[RepositoryModel]> {
        guard let searchName = repositoryName else {
            return Observable.create {
                $0.onCompleted()
                return Disposables.create()
            }
        }
        
        return Observable.create({ (observer: AnyObserver<[RepositoryModel]>) -> Disposable in
            
            let url = "https://api.github.com/search/repositories"
            let parameters = [
                "q": searchName + "stars:>=2000"
            ]
            let request = Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let json):
                    let info = self.parseGithubResponse(response: json as AnyObject)
                    observer.on(.next(info))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    private func parseGithubResponse(response: AnyObject) -> [RepositoryModel] {
        let json = JSON(response)
        let totalCount = json["total_count"].int
        
        var ret: [RepositoryModel] = []
        
        if totalCount != 0 {
            let items = json["items"]
            
            for (_, subJson): (String, JSON) in items {
                let fullName = subJson["full_name"].stringValue
                let description = subJson["description"].stringValue
                let htmlUrl = subJson["html_url"].stringValue
                let avatarUrl = subJson["owner"]["avatar_url"].stringValue
                
                let model: RepositoryModel = RepositoryModel(full_name: fullName, description: description, html_url: htmlUrl, avatar_url: avatarUrl)
                ret.append(model)
            }
        }
        
        return ret
    }
    
    private func displayErrorAlert(error: Error) {
        let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func createGithubSectionModel(repoInfo: [RepositoryModel]) -> [SectionTableModel] {
        
        var ret: [SectionTableModel] = []
        var items: [RepositoryModel] = []
        if repoInfo.count <= 10 {
            let sectionLabel = "Top 1 - 10"
            ret.append(SectionTableModel.init(model: sectionLabel, items: repoInfo))
        } else {
            for i in 1...repoInfo.count {
                items.append(repoInfo[i - 1])
                
                if (i / 10 != 0 && i % 10 == 0) {
                    let sectionLabel = "Top \(i - 9) - \(i)"
                    ret.append(SectionTableModel.init(model: sectionLabel, items: items))
                    items = []
                }
            }
        }
        return ret
    }
}
