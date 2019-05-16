//
//  ProjectFormViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectFormViewController: UIViewController {

    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var notesTextview: UITextView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataController: DataController!
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        if validate() {
            let name = projectTextField.text
            let date = datePicker.date
            let priority = getPriority()
            let notes = notesTextview.text
            let notification = notificationSwitch.isOn
            
            let project = Project(context: dataController.viewContext)
            project.name = name
            project.dueDate = date
            project.priority = priority
            project.notes = notes
            project.notification = notification
            
            try? dataController.viewContext.save()
            dismiss(animated: true, completion: nil)
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
    
    func validate() -> Bool {
        let textValidation = projectTextField.text != nil && projectTextField.text!.count > 0
        let dateValidation = datePicker.date.isGreaterThanDate(Date())
        return textValidation && dateValidation
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
