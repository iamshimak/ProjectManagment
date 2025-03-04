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
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var taskErroLabel: UILabel!
    @IBOutlet weak var dateErroLabel: UILabel!
    @IBOutlet weak var endDateErroLabel: UILabel!
    
    var dataController: DataController!
    var editTask: Task?
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
    }
    
    func setupForm() {
        taskErroLabel.isHidden = true
        dateErroLabel.isHidden = true
        endDateErroLabel.isHidden = true
        
        startDatePicker.minimumDate = Date()
        startDatePicker.maximumDate = project.dueDate!
        startDatePicker.addTarget(self, action: #selector(startDateDidEnd(_:)), for: .valueChanged)
        
        dueDatePicker.minimumDate = Date().addDays(daysToAdd: 1)
        dueDatePicker.maximumDate = project.dueDate!
        
        guard let task = editTask else {
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
            taskErroLabel.isHidden = true
            
            var task: Task! = nil
            if editTask != nil {
                task = editTask
            } else {
                task = Task(context: dataController.viewContext)
            }
            
            task.name = taskTextField.text
            task.notes = notesTextField.text
            task.startDate = startDatePicker.date
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
        if !textValidation {
            taskErroLabel.isHidden = false
        }
        
        let dateValidation = dueDatePicker.date.isGreaterThanDate(Date())
        return textValidation && dateValidation
    }
    
    @objc func startDateDidEnd(_ sender: UIDatePicker) {
        dueDatePicker.minimumDate = sender.date.addDays(daysToAdd: 1)
    }
    

    func endDateDidEnd(_ sender: UIDatePicker) {
        
    }
}
