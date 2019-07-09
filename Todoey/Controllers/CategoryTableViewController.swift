//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Akshansh Gusain on 08/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipTableViewController {
    
    

    var itemArray: Results<Category>?//ne Repositiory
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        loadItems()

    }
    
    //Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemArray?[indexPath.row].name ?? "NO Categories added yet"
        cell.backgroundColor = UIColor(hexString: itemArray?[indexPath.row].color ?? "#fff")
       // cell.backgroundColor = UIColor.randomFlat
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToItem"){
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = itemArray?[indexPath.row] 
                
            }
        }
    }
    

    func saveData(itemObject: Category){
        
        do{
            try realm.write {
                realm.add(itemObject)
            }
        }catch{
            print("Error Encoding,\(error)")
        }
    }
    
    
    func loadItems()
    {
      itemArray = realm.objects(Category.self)
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


    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success!"+textField.text!)
            
            let itemO = Category()
            itemO.name = textField.text!
            itemO.color = UIColor.randomFlat.hexValue()
            self.saveData(itemObject: itemO)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
   
    
}

