//
//  Task+Extension.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/17/19.
//  Copyright © 2019 sk. All rights reserved.
//

import Foundation

extension Task {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        startDate = Date()
    }
}
