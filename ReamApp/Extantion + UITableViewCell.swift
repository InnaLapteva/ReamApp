//
//  Extantion + UITableViewCell.swift
//  ReamApp
//
//  Created by Инна Лаптева on 22.03.2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func configure(with tasklist: TaskList) {
        
        let currnetTasks = tasklist.tasks.filter("isComplet = false")
        let completedTasks = tasklist.tasks.filter("isComplet = true")
        
        textLabel?.text = tasklist.name
        
        if !currnetTasks.isEmpty {
            detailTextLabel?.text = ("\(currnetTasks.count)")
           // accessoryType = .none
        } else if completedTasks.isEmpty {
          //  detailTextLabel?.text = nil
           // accessoryType = .checkmark
            
            detailTextLabel?.text = "✅"
        } else {
            detailTextLabel?.text = "0"
          //  accessoryType = .none
        }
        
    }
}
