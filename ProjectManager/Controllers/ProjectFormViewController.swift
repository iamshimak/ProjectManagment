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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    var dataController: DataController!
    var editProject: Project?
    var onAddToCalender: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
    }
    
    func setupForm() {
        nameErrorLabel.isHidden = true
        guard let project = editProject else {
            datePicker.minimumDate = Date().addDays(daysToAdd: 1)
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
            nameErrorLabel.isHidden = true
            
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
            prioritySegment.selectedSegmentIndex = 0
        case "medium":
            prioritySegment.selectedSegmentIndex = 1
        case "high":
            prioritySegment.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    func validate() -> Bool {
        let textValidation = projectTextField.text != nil && projectTextField.text!.count > 0
        
        if !textValidation {
            nameErrorLabel.isHidden = false
        }
        
        let dateValidation = datePicker.date.isGreaterThanDate(Date())
        return textValidation && dateValidation
    }
}
