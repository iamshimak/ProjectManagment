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
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var taskLeftView: ProgressView!
    @IBOutlet weak var daysTilDueView: ProgressView!

    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.lineCap = .butt
        taskLeftView.lineCap = .butt
        daysTilDueView.lineCap = .butt
        
        progressView.layoutSubviews()
        taskLeftView.layoutSubviews()
        daysTilDueView.layoutSubviews()
    }
}
