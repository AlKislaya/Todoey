//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alexandra on 2.11.25.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= categories.count {
            print("err_indexOutOfRange")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Outlets.TableView.ReusableCell.category, for: indexPath)
                    as! SwipeTableViewCell
        
        var config = cell.defaultContentConfiguration()
        config.text = categories[indexPath.row].name
        cell.contentConfiguration = config
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        if indexPath == nil {
            print("err_noSelectedRow")
            return
        }
        destination.selectedCategory = categories[indexPath!.row]
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: Constants.Views.Alert.addNewCategory, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Views.Alert.addCategory, style: .default) { alertAction in
            
            let newCategory = alertTextField.text
            if  newCategory == nil || newCategory!.isEmpty {
                print("err_categoryIsNilOrEmpty")
                return
            }
            let category = Category(context: self.context)
            category.name = newCategory
            
            self.categories.append(category)
            self.saveData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = Constants.Views.Alert.createNewCategory
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
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func deleteCategory(index: Int) {
        context.delete(categories[index])
        categories.remove(at: index)
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: Constants.Views.Label.delete) { action, indexPath in
            self.deleteCategory(index: indexPath.row)
        }
        
        deleteAction.image = UIImage(named: Constants.Assets.Images.trashIcon)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
