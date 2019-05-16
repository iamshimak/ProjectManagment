//
//  ProjectDetailViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ProjectDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var project: Project! {
        didSet {
            refreshUI()
        }
    }
    
    var dataController: DataController!
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    func refreshUI() {
        loadViewIfNeeded()
        // nameLabel.text = monster?.name
        // descriptionLabel.text = monster?.description
        // iconImageView.image = monster?.icon
        // weaponImageView.image = monster?.weaponImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TaskFormViewController {
            slideInTransitioningDelegate.direction = .right
            slideInTransitioningDelegate.disableCompactHeight = false
            
            controller.dataController = dataController
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }
    
    @IBAction func addToCalender(_ sender: Any) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion:{ granted, error in
            DispatchQueue.main.async {
                // Present Calender in Main Thread
                if granted && error == nil {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = self.project.name
                    event.endDate = self.project.dueDate
                    event.notes = self.project.notes
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
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

extension ProjectDetailViewController: ProjectSelectionDelegate {
    func projectSelected(_ newProject: Project) {
        project = newProject
    }
}

extension ProjectDetailViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
