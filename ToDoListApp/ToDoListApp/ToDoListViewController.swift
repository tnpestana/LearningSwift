//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 24/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController
{
    
    @IBOutlet weak var todoTable: UITableView!

    var array = ["do shit", "make plans", "put in work"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        todoTable.delegate = self
        todoTable.dataSource = self
    }
    
    @IBAction func addItemTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField()
        { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "ok", style: .default)
        { (action) in
            if !textField.text!.isEmpty
            {
                self.array.append(textField.text!)
                self.todoTable.reloadData()
            }
        }
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = todoTable.dequeueReusableCell(withIdentifier: "idCell") as! TodoTableCell
        cell.todoLbl.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if todoTable.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            todoTable.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            todoTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        todoTable.deselectRow(at: indexPath, animated: true)
    }
}

class TodoTableCell: UITableViewCell
{
    @IBOutlet weak var todoLbl: UILabel!
}
