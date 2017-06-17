//
//  Checklist.swift
//  Checklists
//
//  Created by Silver Chu on 08/06/2017.
//  Copyright © 2017 Silver Chu. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    // 便利构造器必须调用本类中定义的其他构造器，并最终导致一个指定构造器被调用---横向代理
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    // 指定构造器必须调用其直接父类的指定构造器---向上代理
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // 必要构造器(这个方法属于子类重写父类的必要构造器）
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    // 统计未完成item的数量
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    // The functional programming way:
    /*
     func countUncheckedItems() -> Int {
     return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
     }
     */
}
