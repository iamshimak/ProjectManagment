//
//  CalenderEventManager.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/23/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class CalenderEventManager {
    
    public static func createProjectEvent(viewController: UIViewController, project: Project) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion:{ granted, error in
            DispatchQueue.main.async {
                // Present Calender in Main Thread
                if granted && error == nil {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = project.name
                    event.endDate = project.dueDate
                    event.notes = project.notes
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = viewController as? EKEventEditViewDelegate
                    viewController.present(eventController, animated: true, completion: nil)
                }
            }
        })
    }
}
