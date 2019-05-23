//
//  TaskTableViewCell.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, Cell {

    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var progressView: DayCounterView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var progressLevelTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(_ task: Task) {
        taskName.text = task.name
        notesLabel.text = task.notes
        dueDateLabel.text = task.dueDate?.formatDate()
        
        progressLevelTextField.text = "\(task.progressLevel)"
        progressView.progress = CGFloat(task.progressLevel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editAction(_ sender: Any) {
    }
    
}
