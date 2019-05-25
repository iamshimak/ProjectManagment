//
//  ProjectViewModel.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/23/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectViewModel {
    
    func progress(_ project: Project, _ tasks: [Task]?) -> CGFloat {
        if tasks == nil {
            return 0
        }
        
        var progress = 0
        for task in tasks! {
            progress += Int(task.progressLevel)
        }
        
        var average = 0
        if tasks!.count > 0 && progress > 0 {
            average = progress / tasks!.count
        }
        
        return CGFloat(average)
    }
    
    func tasksLeft(_ tasks: [Task]?) -> CGFloat {
        if tasks == nil {
            return 0
        }
        
        var tasksLeft = 0.0
        for task in tasks! {
            if task.progressLevel == 100 {
                tasksLeft += 1.0
            }
        }
        
        var average = 0.0
        if tasks!.count > 0 && tasksLeft > 0 {
            average = tasksLeft / Double(tasks!.count) * 100
        }
        
        return CGFloat(average)
    }
    
    func daysProgress(_ project: Project) -> CGFloat {
        let days = project.dueDate!.days(sinceDate: project.createdDate!)!
        let leftDays = project.dueDate!.days(sinceDate: Date())!
        let average = Double(leftDays) / Double(days) * 100.0
        return CGFloat(average)
    }
    
    func configure(_ view: ProjectView, project: Project?, tasks: [Task]?) {
        guard let project = project else {
            emptyView(view)
            return
        }
        
        view.isHidden = false
        view.nameLabel.text = project.name
        view.notesLabel.text = project.notes
        view.priorityLabel.text = "Priority - \(project.priority!)"
        view.startDateLabel.text = "Start Date - \(project.createdDate!.formatDate())"
        view.endDateLabel.text = "End Date - \(project.dueDate!.formatDate())"
        
        let days = project.dueDate!.days(sinceDate: Date())!
        view.daysLabel.text = "\(days > 0 ? days : 0)"
        
        view.progressView.progress = progress(project, tasks)
        view.taskLeftView.progress = tasksLeft(tasks)
        view.daysTilDueView.progress = daysProgress(project)
    }
    
    func emptyView(_ view: ProjectView) {
        view.nameLabel.text = ""
        view.notesLabel.text = ""
        view.priorityLabel.text = ""
        view.endDateLabel.text = ""
        view.daysLabel.text = ""
        view.progressView.progress = 0
        view.taskLeftView.progress = 0
        view.daysTilDueView.progress = 0
        view.isHidden = true
    }
}
