//
//  ProjectFormViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectFormViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var notesTextview: UITextView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataController: DataController!
    var editProject: Project?
    var onAddToCalender: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    func setupForm() {
        guard let project = editProject else {
            datePicker.minimumDate = Date()
            return
        }
        
        navigationBar.topItem?.title = "Edit Project \(project.name!)"
        projectTextField.text = project.name
        notesTextview.text = project.notes
        datePicker.date = project.dueDate!.isGreaterThanDate(Date()) ? project.dueDate! : Date()
        setPriority(project.priority!)
        notificationSwitch.isOn = project.notification
    }
    
    @IBAction func save(_ sender: Any) {
        if validate() {
            var project: Project! = nil
            if editProject != nil {
                project = editProject
            } else {
                project = Project(context: dataController.viewContext)
            }
            
            let name = projectTextField.text
            let date = datePicker.date
            let priority = getPriority()
            let notes = notesTextview.text
            let notification = notificationSwitch.isOn
            
            project.name = name
            project.dueDate = date
            project.priority = priority
            project.notes = notes
            project.notification = notification
            
            try? dataController.viewContext.save()
            dismiss(animated: true, completion: {
                if self.notificationSwitch.isOn {
                    self.onAddToCalender?()
                }
            })
        }
    }
    
    func getPriority() -> String {
        var priority = "low"
        switch prioritySegment.selectedSegmentIndex {
        case 0:
            priority = "low"
        case 1:
            priority = "medium"
        case 2:
            priority = "high"
        default:
            break
        }
        
        return priority
    }
    
    func setPriority(_ value: String) {
        switch value {
        case "low":
            prioritySegment.setEnabled(true, forSegmentAt: 0)
        case "medium":
            prioritySegment.setEnabled(true, forSegmentAt: 1)
        case "high":
            prioritySegment.setEnabled(true, forSegmentAt: 2)
        default:
            break
        }
    }
    
    func validate() -> Bool {
        let textValidation = projectTextField.text != nil && projectTextField.text!.count > 0
        let dateValidation = datePicker.date.isGreaterThanDate(Date())
        return textValidation && dateValidation
    }
}
