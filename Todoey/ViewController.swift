//
//  ViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 05/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let arrayKey = "todoListItemArray"
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: arrayKey) as? [Item]{
            self.itemArray = items
        }
        itemArray.append(Item(item: "find mike", isDone: false))
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
        itemArray.append(Item(item: "eat food", isDone: false))
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
        cell.textLabel?.text = item.item
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
        if itemArray[indexPath.row].isDone == false{
            itemArray[indexPath.row].isDone = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else{
            itemArray[indexPath.row].isDone = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        //tableView.reloadData()
    }
    
    //  MARK: add new items

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        var textField:UITextField?
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { (action) in
            if let tf = textField{
                if(tf.text!.count > 0){
                    self.itemArray.append(Item(item: tf.text!, isDone: false))
                    //self.defaults.set(self.itemArray, forKey:self.arrayKey)
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
    
}

