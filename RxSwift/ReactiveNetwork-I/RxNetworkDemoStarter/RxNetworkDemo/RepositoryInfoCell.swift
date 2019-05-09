//
//  RepositoryInfoCell.swift
//  RxNetworkDemo
//
//  Created by kuroky on 2019/5/8.
//  Copyright © 2019 Boxue. All rights reserved.
//

import UIKit

class RepositoryInfoCell: UITableViewCell {

    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
