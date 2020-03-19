//
//  AlertController.swift
//  ReamApp
//
//  Created by Manager on 19/03/2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    func actionWithTaskList(completion: @escaping (String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { (textField) in
            textField.placeholder = "List Name"
        }
    }
    
    func actionWithTask(completion: @escaping (String, String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(newValue, note)
            } else {
                completion(newValue, "")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { (textField) in
            textField.placeholder = "New Task"
        }
        addTextField { (textField) in
            textField.placeholder = "Note"
        }
    }
    
}
