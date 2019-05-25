//
//  ProjectView.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/23/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var progressView: DayCounterView!
    @IBOutlet weak var taskLeftView: DayCounterView!
    @IBOutlet weak var daysTilDueView: DayCounterView!

    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.layoutSubviews()
        taskLeftView.layoutSubviews()
        daysTilDueView.layoutSubviews()
    }
}
