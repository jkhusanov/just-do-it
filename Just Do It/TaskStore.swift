//
//  TaskStore.swift
//  Just Do It
//
//  Created by Jakhongir Khusanov on 4/30/19.
//  Copyright © 2019 Jakhongir Khusanov. All rights reserved.
//

import Foundation

class TaskStore {
    var tasks = [[Task](), [Task]()]
    
    func add(_ task: Task, at index: Int, isDone: Bool=false) {
        let status = isDone ? 1 : 0
        tasks[status].insert(task, at: index)
    }
    
    
   @discardableResult func removeTask(at index: Int, isDone: Bool = false) -> Task {
        let status = isDone ? 1 : 0
        return tasks[status].remove(at: index)
    }
}
