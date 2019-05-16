//
//  ProjectTableViewCell.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "ProjectTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
