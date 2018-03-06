//
//  ViewController.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 05/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Kill Giant", "Go to High Monks", "What the hell is a High Monk???"]
    var isChecked:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        cell.textLabel?.text = itemArray[indexPath.row]
        if isChecked.contains(String(indexPath.row)){
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if !isChecked.contains(String(indexPath.row)){
            isChecked.append(String(indexPath.row))
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else{
            if let i = isChecked.index(of: String(indexPath.row)){
                isChecked.remove(at: i)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        //tableView.reloadData()
    }


}

