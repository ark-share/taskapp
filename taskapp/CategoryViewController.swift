//
//  CategoryViewController.swift
//  taskapp
//
//  Created by macpc on 2016/07/28.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit

import RealmSwift


class CategoryViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    let realm = try! Realm()
    var category:Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 背景タップでキーボードを隠す
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.category.name = self.nameTextField.text!
            self.realm.add(self.category, update: true)
        }
        
        super.viewWillDisappear(animated)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

}
