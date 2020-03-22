//
//  TaskList.swift
//  ReamApp
//
//  Created by Инна Лаптева on 19.03.2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
