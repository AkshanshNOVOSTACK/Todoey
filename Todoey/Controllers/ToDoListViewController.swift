//
//  ViewController.swift
//  Todoey
//
//  Created by Akshansh Gusain on 04/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Josh"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Ross"
        itemArray.append(newItem3)
        
        if let users = userDefaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = users
        }
    }
    
    //Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        itemArray[indexPath.row].done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
    //Table View Delegate Method for dececting Row Selected  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
         tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK - Add new Items IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success!"+textField.text!)
            
            let itemO = Item()
            itemO.title = textField.text!
            self.itemArray.append(itemO)
            
            self.userDefaults.set(self.itemArray, forKey: "ToDoListArray")
        
            
            self.tableView.reloadData()
        }
//        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action2) in
//            print("Cancel")
//        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
             textField = alertTextField
        }
        alert.addAction(action)
        //alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }
    
}

