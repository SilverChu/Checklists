//
//  DataModel.swift
//  Checklists
//
//  Created by Silver Chu on 10/06/2017.
//  Copyright © 2017 Silver Chu. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    // 设置或返回一个被选中checklist的索引值
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // 获取app下Documents的全路径地址
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    // 根据Documents路径将Checklists.plist添加进去
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // 将数据写入到plist文件中
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // 将数据从plist文件中读取出来
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            
            unarchiver.finishDecoding()
            
            sortChecklists()
        }
    }
    
    // 启动App时，注册一些默认数据
    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0 ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // 初次启动App时进行的处理
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        // 会自动构造一个Checklist
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // 针对checklists排序
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    // 设置ItemID用来对应每个item的Notification
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
}
