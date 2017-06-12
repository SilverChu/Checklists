//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Silver Chu on 2017/5/31.
//  Copyright © 2017年 Silver Chu. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
 
    /*
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        super.init()
    }
    */
    
    func toggleChecked() {
        checked =  !checked
    }
}
