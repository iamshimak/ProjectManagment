//
//  Project+Extensions.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/17/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation

extension Project {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdDate = Date()
    }
}
