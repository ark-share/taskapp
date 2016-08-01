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
    
    //dynamic var category = "" // TextField　非表示にしたので使ってない。
    dynamic var category_id = -1 // Picker用 0だとデータが入っちゃうので未選択として-1にしておく
    
    let categories = LinkingObjects(fromType: Category.self, property: "tasks") // カテゴリへの参照を可能にする？
    //dynamic var category: Category? // この方法は違う？

    
    dynamic var title = ""
    
    dynamic var contents = ""
    
    dynamic var date = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}