//
//  PhotoCollectionViewCell.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/26.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    var isCheckmarked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectImageView.isHidden = true
    }
    
    func configSelect() {
        self.isCheckmarked = !self.isCheckmarked
        self.selectImageView.isHidden = !self.isCheckmarked
    }

}
