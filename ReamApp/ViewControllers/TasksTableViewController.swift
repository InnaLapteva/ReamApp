//
//  TasksTableViewController.swift
//  ReamApp
//
//  Created by Manager on 19/03/2020.
//  Copyright © 2020 Inna. All rights reserved.
//

import UIKit
import RealmSwift

class TasksTableViewController: UITableViewController {
    
    var currentTasksList: TaskList!
  private  var currentTasks: Results<Task>!
    private var completedTask: Results<Task>!
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentTasksList.name
        sortingTasks()
        
    }
    
    //MARK: IBAction
    
    @IBAction func addedButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTask.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Current Tasks" : "Completed Tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
        
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentTask = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(task: currentTask)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.showAlert(with: currentTask)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (_, _, _) in
            StorageManager.shared.done(task: currentTask)
            self.sortingTasks()
            
        }
        editAction.backgroundColor = .orange
        editAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
// MARK: - Private Methods
extension TasksTableViewController {
    
    private func sortingTasks() {
        
        currentTasks = currentTasksList.tasks.filter("isComplet = false")
        completedTask = currentTasksList.tasks.filter("isComplet = true")
        tableView.reloadData()
        
    }
    
    private func showAlert(with task: Task? = nil) {
        
        let alert = AlertController(title: "New List", message: "What do you whant to do", preferredStyle: .alert)
        
        alert.actionWithTask(for: task, completion: { (newName, newNote) in
            
            if let task = task {
                StorageManager.shared.edit(task: task, with: newName, and: newNote)
                self.sortingTasks()
            } else {
                
                let task = Task()
                task.name = newName
                task.note = newNote
                StorageManager.shared.save(task: task, taskList: self.currentTasksList)
                let rowIndex =  IndexPath(row: self.currentTasks.count - 1, section: 0)
                self.tableView.insertRows(at: [rowIndex], with: .automatic)
                self.sortingTasks()
            }
        })
        present(alert, animated: true)
        
    }
}

