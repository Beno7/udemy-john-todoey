//
//  ViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 05/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var items: Results<Item>!
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone == true ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
//                    item.isDone = !item.isDone
                    realm.delete(item)
                }
            } catch{
                print("error on checking item \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
        self.tableView.reloadData()
    }
    
    //  MARK: add new items

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { (action) in
            if let tf = textField{
                if(tf.text!.count > 0){
                    if let currentCategory = self.selectedCategory{
                        do{
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = tf.text!
                                currentCategory.items.append(newItem)
                            }
                        } catch{
                            print("error saving context: \(error)")
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addTextField { (tField) in
            tField.placeholder = "Create new item"
            textField = tField
            print("Now")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func search(_ text:String){
        items = items?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else{
            search(searchBar.text!)
        }
    }
    
}

