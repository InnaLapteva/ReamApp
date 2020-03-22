//
//  TaskListTableViewController.swift
//  ReamApp
//
//  Created by Manager on 19/03/2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListTableViewController: UITableViewController {

    var tasksLists: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //запрос к базе данных
        tasksLists = realm.objects(TaskList.self)
        navigationItem.leftBarButtonItem = editButtonItem
        
        //пример работы с realm DB
//        let shoppingList = TaskList()
//        shoppingList.name = "Shopping List"
//
//        let moviesList = TaskList(value: ["Movies List", Date(), [["Best film"], ["Some another film", "so-so", Date(), true]]])
//
//        let buyMilk = Task()
//        buyMilk.name = "Buy some milk"
//        buyMilk.note = "about 2L"
//
//        let bread = Task(value: ["Bread", "", Date(), false])
//        let apples = Task(value: ["name": "buy apples", "isComplet" : true ])
//
//        shoppingList.tasks.append(buyMilk)
//        shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
//
//        DispatchQueue.main.async {
//            DataManager.shared.saveTaskList([shoppingList, moviesList])
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
           tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = tasksLists[indexPath.row]
        cell.configure(with: taskList)
        
        //let uncomplitedTasks = taskList.tasks.count
//        for task in taskList.tasks {
//            if !task.isComplet {
//                uncomplitedTasks += 1
//            }
//        }
      //  cell.detailTextLabel?.text = "\(uncomplitedTasks)"
        return cell
    }
     // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let currentList = tasksLists[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.shared.delete(taskList: currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            self.showAlert(with: currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.shared.done(taskList: currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        
        return [editAction, deleteAction, doneAction]
        
        
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let tasksList = tasksLists[indexPath.row]
        let tasksVC = segue.destination as! TasksTableViewController
        tasksVC.currentTasksList = tasksList
    }
   

}
   // MARK: - Private Methods
extension TaskListTableViewController {
    
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        
        let alert = AlertController(title: "New List", message: "What do you whant to do", preferredStyle: .alert)
        
        alert.actionWithTaskList(for: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList: taskList, with: newValue)
                completion()
            } else {
            let taskList = TaskList()
            taskList.name = newValue
            StorageManager.shared.save(taskList: taskList)
            let rowIndex =  IndexPath(row: self.tasksLists.count - 1, section: 0)
            self.tableView.insertRows(at: [rowIndex], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
    
}

