//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Silver Chu on 2017/5/31.
//  Copyright © 2017年 Silver Chu. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked =  !checked
    }
}
