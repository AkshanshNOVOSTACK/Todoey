//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Akshansh Gusain on 08/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    var itemArray: Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    
    //Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = itemArray?[indexPath.row].name ?? "NO Categories added yet"
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


    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success!"+textField.text!)
            
            let itemO = Category()
            itemO.name = textField.text!
            
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
