//
//  Task.swift
//  ReamApp
//
//  Created by Инна Лаптева on 19.03.2020.
//  Copyright © 2020 Inna. All rights reserved.
//
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplet = Bool()
}
