//
//  ViewController.swift
//  Todoey
//
//  Created by Akshansh Gusain on 04/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipTableViewController {
    
    var itemArray: Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else{
                fatalError("Navigation Controller does not exist.")
            }
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
            navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)
             searchBar.barTintColor = UIColor(hexString: colorHex)
        }
       
    }
    
    //Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = itemArray?[indexPath.row].title
        
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        itemArray?[indexPath.row].done ?? false ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
    
    
    
    //Table View Delegate Method for dececting Row Selected  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    // realm.delete(item)// Delete Item from database
                    item.done = !item.done
                }
            }catch{
                print("Error UIpdateing \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    /////hjvjkkx
    
    
    //MARK - Add new Items IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success!"+textField.text!)
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let itemO = Item()
                        itemO.title = textField.text!
                        itemO.done = false
                        itemO.date = Date()
                        currentCategory.items.append(itemO)
                    }
                }catch{
                    print("Error saving\(error)")
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func loadItems()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.itemArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error Deleting \(error)")
            }
        }
    }
    
    
    
}

//MARK - Searchbar Delegate methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "date ", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
