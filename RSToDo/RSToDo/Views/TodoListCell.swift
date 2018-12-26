//
//  TodoListCell.swift
//  RSToDo
//
//  Created by kuroky on 2018/12/25.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {

    @IBOutlet weak var finishTag: UILabel!
    @IBOutlet weak var todoNameLabel: UILabel!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configItem(item: TodoItem) {
        finishTag.isHidden = !item.isFinished
        todoNameLabel.text = item.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
