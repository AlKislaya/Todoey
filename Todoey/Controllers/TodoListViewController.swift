//
//  ViewController.swift
//  Todoey
//
//  Created by Alexandra on 28.10.25.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Outlets.TableView.ReusableCell.toDoList, for: indexPath)
        
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
        saveData()
        
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
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = Constants.Views.Alert.createNewItem
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func saveData() {
        do {
            try context.save()
            print("Saved successfully")
        } catch {
            print(error)
        }
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: Constants.Database.Predicate.categoryNameMatchesString, selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func deleteItem(index: Int) {
        context.delete(itemArray[index])
        itemArray.remove(at: index)
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadData()
            return
        }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: Constants.Database.Predicate.titleContainsString, searchText)
        loadData(with: request, predicate: predicate)
    }
}
