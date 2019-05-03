//
//  TableController.swift
//  Just Do It
//
//  Created by Jakhongir Khusanov on 4/30/19.
//  Copyright © 2019 Jakhongir Khusanov. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    
    var taskStore = TaskStore()
    
    override func viewDidLoad() {
        super.viewDidLoad() // calls tableViewController's viewDidLoad method
        
        let uncompletedTasks = [Task(name: "Buy meat"), Task(name: "Buy bread"), Task(name: "Cook food")]
        let completedTasks = [Task(name: "Do homework")]
        
        taskStore.tasks = [uncompletedTasks, completedTasks]
    }
    
  
    @IBAction func addTask(_ sender: UIBarButtonItem) {
       // Setting up alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up actions
        let addAction = UIAlertAction(title: "Add", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add text field
        alertController.addTextField {
            textField in
            textField.placeholder = "Enter a new task"
            
        }
        
        // Add actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present
        present(alertController, animated: true)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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

