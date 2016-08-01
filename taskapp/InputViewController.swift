//
//  InputViewController.swift
//  taskapp
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit

import RealmSwift

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var categoryTextField: UITextField! // もともとあったカテゴリ入力は残しておく。別途、pickerを使った選択に変更中
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task:Task!
    
    var categoryArray = try! Realm().objects(Category).sorted("id", ascending: true)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景タップでキーボードを隠す
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //categoryTextField.text = task.category
        if task.category_id >= 0 {
            pickerView.selectRow(task.category_id, inComponent: 0, animated: true) // 保存したカテゴリを選択させる
        }
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            //self.task.category = self.categoryTextField.text!
            self.task.category_id = self.pickerView.selectedRowInComponent(0) // 選択中のrowを得る。列が１つなら引数componentは「0」番目を指定すればいいのかな？
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task)

        super.viewWillDisappear(animated)
    }

    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // ローカル通知を設定する
    func setNotification(task: Task) {
        // 編集前のタスクは削除
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                print("古い通知を削除 ID.\(task.id)")
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        // アラートが未来ならローカル通知を作る
        let now = NSDate()
        if now.compare(task.date) == NSComparisonResult.OrderedAscending {
        
            let notification = UILocalNotification()
            
            notification.fireDate = task.date
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "\(task.title)"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["id":task.id]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
 
    
    // 画面遷移
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:CategoryViewController = segue.destinationViewController as! CategoryViewController
        
        let category = Category()
        
        if categoryArray.count != 0 {
            category.id = categoryArray.max("id")! + 1
        }
        
        vc.category = category
        
    }
    
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
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(row)
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.reloadAllComponents()
    }
}
