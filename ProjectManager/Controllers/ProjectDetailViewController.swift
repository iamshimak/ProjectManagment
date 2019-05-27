//
//  ProjectDetailViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import EventKitUI

class ProjectDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var projectView: ProjectView!
    
    var project: Project! {
        didSet {
            refreshUI()
        }
    }
    
    var projectViewModel: ProjectViewModel = ProjectViewModel()
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Task>!
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    var selectedTaskIndex: IndexPath!
    
    func refreshUI() {
        loadViewIfNeeded()
    }
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "project == %@", project)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: "\(String(describing: project.objectID))-tasks")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHide()
        
        projectViewModel.configure(projectView, project: nil, tasks: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        projectView.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard project != nil else {
            return
        }
        
        setupFetchedResultsController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupKeyboardHide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Deletes the task at the specified index path
    func deleteTask(at indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(task)
        try? dataController.viewContext.save()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard project != nil else {
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TaskFormViewController {
            slideInTransitioningDelegate.direction = .right
            // slideInTransitioningDelegate.disableCompactHeight = false
            
            controller.dataController = dataController
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
            controller.project = project
            
            if segue.identifier == "EditTask" {
                controller.editTask = fetchedResultsController.object(at: selectedTaskIndex)
            }
        }
    }
    
    @IBAction func addToCalender(_ sender: Any?) {
        CalenderEventManager.createProjectEvent(viewController: self, project: project)
    }

}

extension ProjectDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard fetchedResultsController != nil else { return 0 }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        // return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.defaultReuseIdentifier, for: indexPath) as! TaskTableViewCell
        cell.setupCell(task, dataController: dataController)
        return cell
    }
    
}

extension ProjectDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete: deleteTask(at: indexPath)
            default: () // Unsupported
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { action, indexpath in
            self.selectedTaskIndex = indexPath
            self.performSegue(withIdentifier: "EditTask", sender: nil)
        });
        edit.backgroundColor = UIColor.blue;
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexpath in
            self.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        });
        
        return [delete, edit];
    }
}

extension ProjectDetailViewController: ProjectSelectionDelegate {
    func projectSelected(_ newProject: Project?) {
        project = newProject
        setupFetchedResultsController()
        let tasks = fetchedResultsController.fetchedObjects
        projectViewModel.configure(projectView, project: project, tasks: tasks)
        tableView.reloadData()
    }
    
    func projectDeleted() {
        if tableView != nil {
            projectViewModel.configure(projectView, project: nil, tasks: nil)
            tableView.reloadData()
        }
    }
    
    func projectUpdated(_ newProject: Project?) {
        project = newProject
        setupFetchedResultsController()
        let tasks = fetchedResultsController.fetchedObjects
        projectViewModel.configure(projectView, project: project, tasks: tasks)
    }
    
    func projectInserted(_ newProject: Project?) {
        project = newProject
        setupFetchedResultsController()
        let tasks = fetchedResultsController.fetchedObjects
        projectViewModel.configure(projectView, project: project, tasks: tasks)
    }
}

extension ProjectDetailViewController: NSFetchedResultsControllerDelegate {
    
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
            tableView.reloadData()
            break
        case .update:
            let tasks = fetchedResultsController.fetchedObjects
            projectViewModel.configure(projectView, project: project, tasks: tasks)
            tableView.reloadRows(at: [indexPath!], with: .none)
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

extension ProjectDetailViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
