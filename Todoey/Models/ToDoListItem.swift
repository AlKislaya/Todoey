//
//  ToDoListItem.swift
//  Todoey
//
//  Created by Alexandra on 29.10.25.
//

import UIKit

class ToDoListItem: Codable {
    let task: String
    var isDone: Bool = false
    
    init(task: String) {
        self.task = task
    }
}
