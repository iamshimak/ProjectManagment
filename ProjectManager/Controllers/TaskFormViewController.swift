//
//  TaskFormViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class TaskFormViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataController: DataController!
    var editTask: Task?
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDatePicker.minimumDate = Date()
        dueDatePicker.maximumDate = project.dueDate!
        setupForm()
    }
    
    func setupForm() {
        guard let task = editTask else {
            dueDatePicker.minimumDate = Date()
            return
        }
        
        navigationBar.topItem?.title = "Edit Task \(task.name!)"
        taskTextField.text = task.name
        notesTextField.text = task.notes
        dueDatePicker.date = task.dueDate!.isGreaterThanDate(Date()) ? task.dueDate! : Date()
        notificationSwitch.isOn = task.taskReminder
    }
    
    @IBAction func save(_ sender: Any) {
        if validate() {
            var task: Task! = nil
            if editTask != nil {
                task = editTask
            } else {
                task = Task(context: dataController.viewContext)
            }
            
            task.name = taskTextField.text
            task.notes = notesTextField.text
            task.dueDate = dueDatePicker.date
            task.taskReminder = notificationSwitch.isOn
            task.project = project
            
            if editTask == nil && notificationSwitch.isOn {
                NotificationManager.shared.scheduleNotificationFor(task: task)
            }
            
            try? dataController.viewContext.save()
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func validate() -> Bool {
        let textValidation = taskTextField.text != nil && taskTextField.text!.count > 0
        let dateValidation = dueDatePicker.date.isGreaterThanDate(Date())
        return textValidation && dateValidation
    }

}
