//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Akshansh Gusain on 08/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var itemArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    
    //Data Source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToItem"){
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = itemArray[indexPath.row]
                
            }
        }
    }
    

    func saveData(){
        
        do{
            try context.save()
        }catch{
            print("Error Encoding,\(error)")
        }
    }
    
    func loadItems()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching,\(error)")
        }
    }


    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success!"+textField.text!)
            
            let itemO = Category(context: self.context)
            itemO.name = textField.text!
        
            self.itemArray.append(itemO)
            
            self.saveData()
            
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
