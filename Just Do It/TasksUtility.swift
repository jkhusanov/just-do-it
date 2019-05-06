//
//  TasksUtility.swift
//  Just Do It
//
//  Created by Jakhongir Khusanov on 5/5/19.
//  Copyright © 2019 Jakhongir Khusanov. All rights reserved.
//

import Foundation

class TasksUtility {
    
    private static let key = "tasks"
    
    // Archive data
    private static func archive(_ tasks: [[Task]]) -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
    }
    
    // Fetch data
    static func fetch() -> [[Task]]? {
        guard let fetchedData = UserDefaults.standard.object(forKey: key) as? Data else {return nil}
        
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fetchedData) as? [[Task]]
        }
        catch {
            print(error)
            return nil
        }
    }
    
    // Save Data
    static func save(_ tasks: [[Task]]) {
        // Archive
        let archivedTasks = archive(tasks)
        
        // Set object for key
        UserDefaults.standard.set(archivedTasks, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
