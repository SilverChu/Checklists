//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Silver Chu on 2017/5/25.
//  Copyright © 2017年 Silver Chu. All rights reserved.
//

import UIKit

// Delegate - Step 4 实现被代理对象的协议
class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    // var items: [ChecklistItem] // Array which stores ChecklistItem, and the index correspond to the row.
    var checklist: Checklist! // Checklist.swift has initialized "var items = [ChecklistItem]()"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name // 初始化item屏幕上title为checklist的名字
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // initialize some data
    /*
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        super.init(coder: aDecoder)
        print("\(documentsDirectory())")
        loadChecklistItems()
    }
    */
    
    // Delegate - Step 4 实现被代理对象的协议中的方法
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        
        // saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        
        // saveChecklistItems()
    }
    
    // Prepare-for-segue 用来描述跳转的相关信息，sender表示是哪个控件触发了跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self // Delegate - Step 5 告知ItemDetailViewController，ChecklistViewController是它的代理
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self // Delegate - Step 5 告知ItemDetailViewController，ChecklistViewController是它的代理
            
            // 将所点击的item传递给itemToEdit变量使用，这里的sender就是编辑按钮
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // UITableView的Data Source中的方法，用于返回一个table view下指定section内rows的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    // UITableView的Data Source中的方法，请求一个cell来插入table view中的某一位置的数据（row）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // UITableView的Delegate中的方法，告诉delegate指定的row被选中
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked() // 切换checklistitem中checked的状态
            
            configureCheckmark(for: cell, with: item) // 开关所点击row的checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        // saveChecklistItems()
    }
    
    // UITableView的Data Source中的方法，主要用于确认某一行数据的插入与删除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        // saveChecklistItems()
    }
    
    // 开关checkmark的方法
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    // 将checklistitem对象的text传递给label对象的text的方法
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.text
        // label.text = "\(item.itemID): \(item.text)"
    }
    
    /*
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    */
    /*
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    */
    /*
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    */
    /*
    func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            
            unarchiver.finishDecoding()
        }
    }
    */
    
}

