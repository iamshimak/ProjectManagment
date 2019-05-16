//
//  Cell.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/17/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation
import UIKit

protocol Cell: class {
    /// A default reuse identifier for the cell class
    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
        // Should return the class's name, without namespacing or mangling.
        // This works as of Swift 3.1.1, but might be fragile.
        return "\(self)"
    }
}

