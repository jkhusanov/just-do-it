//
//  TableController.swift
//  Just Do It
//
//  Created by Jakhongir Khusanov on 4/30/19.
//  Copyright © 2019 Jakhongir Khusanov. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            // Get the data
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](),[Task]()]
            
            // Reload the table
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        // Calls tableViewController's viewDidLoad method
        super.viewDidLoad()
    }
    
  
    @IBAction func addTask(_ sender: UIBarButtonItem) {
       // Setting up alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up actions
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            // Grab text field text
            guard let name = alertController.textFields?.first?.text else { return }
            
            // Create a task
            let newTask = Task(name: name)
            
            // Add task
            self.taskStore.add(newTask, at: 0)
            
            // Save tasks
            TasksUtility.save(self.taskStore.tasks)
            
            // Reload data in the table view
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
            
        }
        addAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add text field
        alertController.addTextField { textField in
            textField.placeholder = "Enter a new task"
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
            
        }
        
        // Add actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        // Grab the alert controller and add action
        guard let alertController = presentedViewController as? UIAlertController,
             let addAction = alertController.actions.first,
            let text = sender.text
            else {
                return
        }
        // Enable or disable add action based on if text is empty or contains only whitespace
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - DataSource
extension TableController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "To-Do"
        } else {
            return "Done"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
}

// MARK: - Delegate
extension TableController {
    
    // Set height of header section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // Change color of header section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(rgb: section == 0 ? 0x0583F2 : 0x55e9bc ).withAlphaComponent(0.7)
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, source, completionHandler) in
            
            // Determine if a task is done
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else {return}
            
            // Remove a task from the appropiate array
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            // Indicate that the actions is performed
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(rgb: 0xff2e63)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, sourceView, completionHandler) in
            
            // Toggle that a task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            // Remove the task from the array containing todo tasks
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            // Reload table view for the todo section
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Add a task from the array containing done tasks
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            // Reload table view for the done section
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            
            // Action is performed
            completionHandler(true)
        }
        doneAction.backgroundColor = UIColor(rgb: 0x00b8a9)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}


// MARK: - Color Helper
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

