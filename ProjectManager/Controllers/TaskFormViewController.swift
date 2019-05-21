//
//  TaskFormViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class TaskFormViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var notesTextField: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataController: DataController!
    var isEdit = false
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        if validate() {
            let task = Task(context: dataController.viewContext)
            task.name = taskTextField.text
            task.notes = notesTextField.text
            task.dueDate = dueDatePicker.date
            task.taskReminder = notificationSwitch.isOn
            task.project = project
            
            try? dataController.viewContext.save()
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func validate() -> Bool {
        let textValidation = taskTextField.text != nil && taskTextField.text!.count > 0
        let dateValidation = dueDatePicker.date.isGreaterThanDate(Date())
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
