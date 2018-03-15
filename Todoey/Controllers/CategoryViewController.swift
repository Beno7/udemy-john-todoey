//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 14/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    var catArray: Results<Category>!
    
    let arrayKey = "todoListCatArray"
    
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCat()
    }

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { (action) in
            if let tf = textField{
                if(tf.text!.count > 0){
                    let newCat = Category()
                    newCat.name = tf.text!
                    self.saveCat(category: newCat)
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
        return catArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        cell.textLabel?.text = catArray?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destVC.selectedCategory = catArray?[indexPath.row]
            }
        }
    }
    
    //MARK: Data Manipulation Methods

    func saveCat(category cat:Category){
        do{
            try realm.write {
                realm.add(cat)
            }
        } catch{
            print("error saving context: \(error)")
        }
    }
    
    func loadCat(){
        catArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    

}
