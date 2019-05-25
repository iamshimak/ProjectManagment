//
//  ProjectTableViewCell.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell, Cell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ project: Project) {
        nameLabel.text = project.name
        dateLabel.text = project.dueDate?.formatDate()
    }

}
