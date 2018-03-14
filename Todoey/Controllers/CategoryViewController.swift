//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 14/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catArray = [Category]()
    
    let arrayKey = "todoListCatArray"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCat()
    }

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { (action) in
            if let tf = textField{
                if(tf.text!.count > 0){
                    let newCat = Category(context: self.context)
                    newCat.name = tf.text!
                    self.catArray.append(newCat)
                    //self.defaults.set(self.itemArray, forKey:self.arrayKey)
                    self.saveCat()
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addTextField { (tField) in
            tField.placeholder = "Create new category"
            textField = tField
            print("Now")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView DataSource/Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cat = catArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        cell.textLabel?.text = cat.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destVC.selectedCategory = catArray[indexPath.row]
            }
        }
    }
    
    //MARK: Data Manipulation Methods

    func saveCat(){
        //let encoder = PropertyListEncoder()
        do{
            //let data = try encoder.encode(self.itemArray)
            //try data.write(to: self.dataFilePath!)
            try context.save()
        } catch{
            print("error saving context: \(error)")
        }
    }
    
    func loadCat(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            catArray = try context.fetch(request)
        } catch{
            print("error fetching data from context \(error)");
        }
        tableView.reloadData()
    }
    

}
