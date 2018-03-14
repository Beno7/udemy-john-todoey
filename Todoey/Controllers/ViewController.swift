//
//  ViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 05/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [ItemEntity]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let arrayKey = "todoListItemArray"
    
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath)
        
        searchBar.delegate = self
        
        /*itemArray.append(Item(item: "find mike", isDone: false))
        itemArray.append(Item(item: "kill demigod", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))
        itemArray.append(Item(item: "eat food", isDone: false))*/
        
        /*if let items = defaults.array(forKey: arrayKey) as? [Item]{
            self.itemArray = items
        }*/
        
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone == true ? .checkmark : .none
        /*if itemArray[indexPath.row].isDone == true{
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }*/
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
//        context.delete(itemArray.remove(at: indexPath.row))
//        itemArray.remove(at: indexPath.row)
        if itemArray[indexPath.row].isDone == false{
            itemArray[indexPath.row].isDone = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else{
            itemArray[indexPath.row].isDone = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.saveItems()
        
        //tableView.reloadData()
    }
    
    //  MARK: add new items

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { (action) in
            if let tf = textField{
                if(tf.text!.count > 0){
                    let newItem = ItemEntity(context: self.context)
                    newItem.title = tf.text!
                    newItem.parentCategory = self.selectedCategory
                    newItem.isDone = false
                    self.itemArray.append(newItem)
                    //self.defaults.set(self.itemArray, forKey:self.arrayKey)
                    self.saveItems()
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
    
    func saveItems(){
        //let encoder = PropertyListEncoder()
        do{
            //let data = try encoder.encode(self.itemArray)
            //try data.write(to: self.dataFilePath!)
            try context.save()
        } catch{
            print("error saving context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (self.selectedCategory?.name)!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        request.predicate = compoundPredicate
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("error fetching data from context \(error)");
        }
        tableView.reloadData()
    }
    
    func search(_ text:String){
        let request:NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate);
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
            search(searchText)
        }
    }
    
}

