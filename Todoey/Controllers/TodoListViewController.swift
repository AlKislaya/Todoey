//
//  ViewController.swift
//  Todoey
//
//  Created by Alexandra on 28.10.25.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [String] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initListOfItems()
    }
    
    func initListOfItems() {
        let items = defaults.array(forKey: Constants.Defaults.toDoList) as? [String]
        if items == nil {
            print("err_noSavedListOfItems")
            return
        }
        
        itemArray = items!
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
            self.defaults.set(self.itemArray, forKey: Constants.Defaults.toDoList)
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
