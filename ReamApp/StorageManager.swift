//
//  DataManager.swift
//  ReamApp
//
//  Created by Инна Лаптева on 20.03.2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import RealmSwift

//глобальное свойство
 let realm = try! Realm()

class StorageManager {
    
    static let shared = StorageManager()
    
    func save(taskList: TaskList) {
        //лучше через do catch
        try! realm.write {
            realm.add(taskList)
        }
    }
    
    func save(task: Task, taskList: TaskList) {
        //лучше через do catch
        try! realm.write {
            taskList.tasks.append(task)
        }
    }

    func delete(taskList: TaskList) {
        try! realm.write {
            let tasks = taskList.tasks
            realm.delete(tasks)
            realm.delete(taskList)
        }
    }
    
    func delete(task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    func edit(taskList: TaskList, with newList: String) {
        try! realm.write {
            taskList.name = newList
        }
    }
    
    func edit(task: Task, with newName: String, and newNote: String) {
        
        try! realm.write {
            task.name = newName
            task.note = newNote
        }
    }
    
    func done(taskList: TaskList) {
        try! realm.write {
            taskList.tasks.setValue(true, forKey: "isComplet")
        }
    }
    
    func done(task: Task) {
        try! realm.write {
            task.isComplet.toggle() // меняем на противоположное
        }
    }
    
}
