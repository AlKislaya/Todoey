//
//  ViewController.swift
//  Todoey
//
//  Created by Alexandra on 28.10.25.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItemsData()
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
        config.text = itemArray[indexPath.row].task
        cell.contentConfiguration = config
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveItemsData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: Constants.Views.Alert.addNewItem, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Views.Alert.addItem, style: .default) { alertAction in
            
            let newTask = alertTextField.text
            if  newTask == nil || newTask!.isEmpty {
                print("err_itemIsNilOrEmpty")
                return
            }
            let newItem = Item(context: self.context)
            newItem.task = newTask
            newItem.isDone = false
            
            self.itemArray.append(newItem)
            self.saveItemsData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            alertTextField.placeholder = Constants.Views.Alert.createNewItem
            alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func saveItemsData() {
        do {
            try context.save()
            print("Saved successfully")
        } catch {
            print(error)
        }
    }
}
