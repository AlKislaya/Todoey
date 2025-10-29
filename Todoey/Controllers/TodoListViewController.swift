//
//  ViewController.swift
//  Todoey
//
//  Created by Alexandra on 28.10.25.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [ToDoListItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.Directory.toDoList)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItemsData()
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
            
            self.itemArray.append(ToDoListItem(task: newTask!))
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
    
    //MARK: - Encode, decode items data
    
    func saveItemsData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error)
        }
    }
    
    func loadItemsData() {
        do {
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([ToDoListItem].self, from: data)
            }
        } catch {
            print(error)
        }
    }
}
