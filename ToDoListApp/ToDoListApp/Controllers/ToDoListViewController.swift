//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 24/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController
{
    
    @IBOutlet weak var todoTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var array: [TodoItem] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        todoTable.delegate = self
        todoTable.dataSource = self
        
        loadData()
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
        
        let action = UIAlertAction(title: "OK", style: .default)
        { (action) in
            if !textField.text!.isEmpty
            {
                
                let newItem = TodoItem(context: self.context)
                newItem.message = textField.text!
                newItem.done = false
                self.array.append(newItem)
                self.saveData()
                self.todoTable.reloadData()
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func loadData()
    {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do
        {
            array = try context.fetch(request)
        }
        catch
        {
            print(error.localizedDescription)
        }
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
        let item = array[indexPath.row]
        cell.todoLbl.text = item.message
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = array[indexPath.row]
        item.done = !item.done
        todoTable.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        saveData()
        todoTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            array.remove(at: indexPath.row)
            todoTable.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
}

class TodoTableCell: UITableViewCell
{
    @IBOutlet weak var todoLbl: UILabel!
}
