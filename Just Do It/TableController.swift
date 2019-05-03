//
//  TableController.swift
//  Just Do It
//
//  Created by Jakhongir Khusanov on 4/30/19.
//  Copyright © 2019 Jakhongir Khusanov. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    
    var taskStore: TaskStore!
    
    override func viewDidLoad() {
        super.viewDidLoad() // calls tableViewController's viewDidLoad method
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
            return "TO-DO"
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
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

