//
//  TaskTableViewCell.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, Cell {

    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var progressLevelTextField: UITextField!
    
    private var task: Task?
    private var dataController: DataController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressLevelTextField.delegate = self
    }
    
    func setupCell(_ task: Task, dataController: DataController) {
        self.task = task
        self.dataController = dataController
        
        taskName.text = task.name
        notesLabel.text = task.notes
        startDate.text = "Start Date \(task.startDate!.formatDate())"
        endDate.text = "End Date \(task.dueDate!.formatDate())"
        
        progressLevelTextField.text = "\(task.progressLevel)"

        let days = task.dueDate!.days(sinceDate: task.startDate!)!
        var leftDays = 0
        var average = 0.0
        if task.startDate!.isGreaterThanDate(Date()) {
            leftDays = task.dueDate!.days(sinceDate: task.startDate!)!
        } else {
            leftDays = task.dueDate!.days(sinceDate: Date())!
        }
        
        if days > 0 && leftDays > 0 {
            average = Double(leftDays) / Double(days) * 100.0
        }
        progressView.progress = CGFloat(average)
    }
    
}

extension TaskTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let string = textField.text, let number = NumberFormatter().number(from: string) {
            task?.progressLevel = Int16(truncating: number)
            try? dataController.viewContext.save()
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let value = textField.text, let swtRange = Range(range, in: value) {
            let fullString = value.replacingCharacters(in: swtRange, with: string)
            if let number = NumberFormatter().number(from: fullString) {
                if Int(truncating: number) <= 100 {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return true
    }
}
