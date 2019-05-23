//
//  ProjectViewModel.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/23/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectViewModel {
    
    private var project: Project!
    private var tasks: [Task]?
    
    var progress: CGFloat {
        if tasks == nil {
            return 0
        }
        
        var progress = 0
        for task in tasks! {
            progress += Int(task.progressLevel)
        }
        
        return CGFloat(progress)
    }
    
    var tasksLeft: CGFloat {
        if tasks == nil {
            return 0
        }
        
        var tasksLeft = 0
        for task in tasks! {
            if task.progressLevel < 100 {
                tasksLeft += 1
            }
        }
        
        return CGFloat(tasks!.count * tasksLeft / 100)
    }
    
    func configure(_ view: ProjectView, project: Project, tasks: [Task]?) {
        view.nameLabel.text = project.name
        view.notesLabel.text = "project notes"
        view.priorityLabel.text = "Priority - \(project.priority!)"
        view.dateLabel.text = project.dueDate!.formatDate()
        
        let days = project.dueDate!.days(sinceDate: Date())!
        view.daysLabel.text = "\(days > 0 ? days : 0)"
        
        view.progressView.progress = progress
        view.taskLeftView.progress = tasksLeft
    }
    
}
