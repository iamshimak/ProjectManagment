//
//  Task.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation

class Task {
    let name: String
    let startDate: Date
    let notes: String
    let dueDate: Date
    let taskReminder: Bool
    
    init(name: String, startDate: Date, notes: String, dueDate: Date, taskReminder: Bool) {
        self.name = name
        self.startDate = startDate
        self.notes = notes
        self.dueDate = dueDate
        self.taskReminder = taskReminder
    }
}
