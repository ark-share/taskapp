//
//  ViewController.swift
//  taskapp
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit

import RealmSwift

// UISearchBarDelegate,
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let realm = try! Realm()
    
    var taskArray = try! Realm().objects(Task).sorted("date", ascending: false)
    
    var categoryArray = try! Realm().objects(Category).sorted("id", ascending: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 自動的に先頭を大文字にしない
        //searchBar.autocapitalizationType = UITextAutocapitalizationType.None
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Cellに値を設定する
        let task = taskArray[indexPath.row]
        //cell.textLabel?.text = task.title
 
        // リレーションを活かしてないデータの取り方？
        if let data = realm.objectForPrimaryKey(Category.self, key: task.category_id) {
            cell.textLabel?.text = "Id.\(task.id) Ti:\(task.title) Ca:\(data.name)"
        }
        
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dataString:String = formatter.stringFromDate(task.date)
        cell.detailTextLabel?.text = dataString
        
        return cell
    }
    
    // Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 選択時
        performSegueWithIdentifier("cellSegue", sender: nil)
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        // 削除判定
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 削除時
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // ローカル通知を削除
            let task = taskArray[indexPath.row]
            // todo: 以下InputViewControllerと同じなので共通化したい
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                if notification.userInfo!["id"] as! Int == task.id {
                    print("通知も同時に削除 ID.\(task.id)")
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
            
            // データベースから削除
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
        
    }
    
    // 画面遷移
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let inputViewController:InputViewController = segue.destinationViewController as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            // 値を送る
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max("id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        pickerView.reloadAllComponents()
    }
    
    // search
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//        
//        if searchText == "" {
//            taskArray = try! Realm().objects(Task).sorted("date", ascending: false)
//        }
//        else {
//            // 前方一致になるかな
//            let prepare = NSPredicate(format: "category BEGINSWITH '\(searchText)'")
//            taskArray = try! Realm().objects(Task).filter(prepare).sorted("date", ascending: false)
//        }
//        
//        tableView.reloadData()
//    }

    // Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時
        let prepare = NSPredicate(format: "category_id = \(row)")
        taskArray = try! Realm().objects(Task).filter(prepare).sorted("date", ascending: false)
        
        tableView.reloadData()
    }
    
}

