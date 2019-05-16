//
//  Project.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation
import UIKit

enum Priority {
    case low, medium, high
}

class Project {
    let name: String
    let priority: Priority
    let dueDate: Date
    let notes: String
    
    init(name: String, priority: Priority, dueDate: Date, notes: String) {
        self.name = name
        self.priority = priority
        self.dueDate = dueDate
        self.notes = notes
    }
}
