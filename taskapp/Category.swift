//
//  Category.swift
//  taskapp
//
//  Created by macpc on 2016/07/28.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import RealmSwift

class Category: Object {
    dynamic var id = 0
    
    dynamic var name = ""
    
    let tasks = List<Task>() // 1対多のリレーション > 間違っているらしい！
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}