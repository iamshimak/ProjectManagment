//
//  ProjectDetailViewController.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/16/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    var project: Project? {
        didSet {
            refreshUI()
        }
    }
    
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
            
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
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
