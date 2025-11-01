//
//  Constants.swift
//  Todoey
//
//  Created by Alexandra on 28.10.25.
//

import UIKit

struct Constants {
    struct Outlets {
        struct TableView {
            static let toDoListReusableCell = "ToDoItemCell"
        }
    }
    struct Views {
        struct Alert {
            static let addItem = "Add item"
            static let addNewItem = "Add new item"
            static let createNewItem = "Create new item"
        }
    }
    struct Database {
        struct Predicate {
            static let titleContainsString = "task CONTAINS[cd] %@"
        }
    }
}
