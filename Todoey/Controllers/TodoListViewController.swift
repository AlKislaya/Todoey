//
//  ViewController.swift
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
}

class TodoListViewController: UITableViewController {

    var itemArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Outlets.TableView.toDoListReusableCell, for: indexPath)
        
        if indexPath.row >= itemArray.count {
            print("err_indexOutOfRange")
            return UITableViewCell()
        }
        
        var config = cell.defaultContentConfiguration()
        config.text = itemArray[indexPath.row]
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAccessoryType = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = currentAccessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: Constants.Views.Alert.addNewItem, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Views.Alert.addItem, style: .default) { alertAction in
            
            let newItem = alertTextField.text
            if  newItem == nil || newItem!.isEmpty {
                print("err_itemIsNilOrEmpty")
                return
            }
            
            self.itemArray.append(alertTextField.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            alertTextField.placeholder = Constants.Views.Alert.createNewItem
            alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
