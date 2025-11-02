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
            struct ReusableCell {
                static let toDoList = "ToDoItemCell"
                static let category = "CategoryCell"
            }
        }
    }
    struct Views {
        struct Alert {
            static let addItem = "Add item"
            static let addNewItem = "Add new item"
            static let createNewItem = "Create new item"
            static let addCategory = "Add Category"
            static let addNewCategory = "Add new Category"
            static let createNewCategory = "Create new Category"
        }
    }
    struct Database {
        struct Predicate {
            static let titleContainsString = "task CONTAINS[cd] %@"
            static let categoryNameMatchesString = "parentCategory.name MATCHES %@"
        }
    }
}
