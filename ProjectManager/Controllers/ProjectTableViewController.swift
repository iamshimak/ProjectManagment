//
//  ProjectTableViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import EventKitUI

protocol ProjectSelectionDelegate: class {
    func projectSelected(_ newProject: Project)
}

class ProjectTableViewController: UITableViewController {
    
    weak var delegate: ProjectSelectionDelegate?
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Project>!
    
    fileprivate func setupFetchedResultsController(_ sortDescriptor: String = "createdDate", assending: Bool = false) {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: assending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: "projects")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func loadResults() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        
        let indexPath = IndexPath(row: 0, section: 0)
        // TODO check indexpath available before select
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Deletes the project at the specified index path
    func deleteProject(at indexPath: IndexPath) {
        let project = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(project)
        try? dataController.viewContext.save()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.defaultReuseIdentifier, for: indexPath) as! ProjectTableViewCell
        cell.setupCell(project)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = fetchedResultsController.object(at: indexPath)
        delegate?.projectSelected(project)
        if let detailViewController = delegate as? ProjectDetailViewController,
            let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteProject(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ProjectEdit" {
            return tableView.indexPathForSelectedRow != nil
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ProjectFormViewController {
            slideInTransitioningDelegate.direction = .left
            slideInTransitioningDelegate.disableCompactHeight = false

            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
            controller.dataController = dataController
            
            if segue.identifier == "ProjectEdit" {
                controller.editProject = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
                
            } else {
                controller.onAddToCalender = {
                    let project = self.fetchedResultsController.fetchedObjects!.last!
                    CalenderEventManager.createProjectEvent(viewController: self, project: project)
                }
            }
        }
    }

}

extension ProjectTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
            let project = fetchedResultsController.object(at: indexPath!)
            delegate?.projectSelected(project)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

extension ProjectTableViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
