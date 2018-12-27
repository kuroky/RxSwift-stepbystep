//
//  PhotoCollectionViewController.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/26.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import Photos
import RxSwift

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    fileprivate let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    fileprivate var photos = PHFetchResult<PHAsset>()
    fileprivate lazy var imageManager = PHCachingImageManager()
    
    fileprivate lazy var thumbnailsize: CGSize = {
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height:  cellSize.height * UIScreen.main.scale)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {
        let isAuthorized = PHPhotoLibrary.isAuthorized.share()
        
        isAuthorized
            .skipWhile { $0 == false }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.photos = PhotoCollectionViewController.loadPhotos()
                self.collectionView.reloadData()
            })
            .disposed(by: bag)
        
        isAuthorized
            .distinctUntilChanged() // 忽略重复
            .takeLast(1)
            .filter { $0 == false }
            .subscribe(onNext: { _ in
                self.flash(title: "Cannot access your photo library",
                           message: "You can authorize access from the Settings.",
                           callback: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            })
            .disposed(by: bag)
    }
    
    func setupUI () {
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView!.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(clickConfirm))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let asset = photos.object(at: indexPath.item)
        imageManager.requestImage(for: asset,
                                  targetSize: thumbnailsize,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler:
            { (image, info) in
                guard let image = image, let info = info else { return }
                if let isThumbnail = info[PHImageResultIsDegradedKey] as? Bool, isThumbnail {
                    cell.photoImageView.image = image
                }
                //if cell.representedAssetIdentifier == asset.localIdentifier {
                //    cell.imageView.image = image
                //}
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else {
            return
        }
        
        cell.configSelect()
        
        let asset = photos.object(at: indexPath.item)
        
        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] (image, info) in
            guard let image = image, let info = info else { return }

            if let isThumbnail = info[PHImageResultIsDegradedKey] as? Bool, !isThumbnail {
                self?.selectedPhotoSubject.onNext(image)
            }
        })
    }
}

extension PhotoCollectionViewController {
    
    @objc func clickConfirm() {
        self.selectedPhotoSubject.onCompleted()
        self.navigationController?.popViewController(animated: true)
    }
    
    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: options)
    }
}
