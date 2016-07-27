//
//  Task.swift
//  taskapp
//
//  Created by macpc on 2016/07/22.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import RealmSwift

class Task: Object {
    dynamic var id = 0
    
    dynamic var category = ""
    
    dynamic var title = ""
    
    dynamic var contents = ""
    
    dynamic var date = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}