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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    var array: [TodoItem] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
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
                let newItem = TodoItem(message: textField.text)
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
        let encoder = PropertyListEncoder()
        do
        {
            let data = try encoder.encode(array)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func loadData()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do
            {
                array = try decoder.decode([TodoItem].self, from: data)
            }
            catch
            {
                print(error.localizedDescription)
            }
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
        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = array[indexPath.row]
        item.isChecked = !item.isChecked
        todoTable.cellForRow(at: indexPath)?.accessoryType = item.isChecked ? .checkmark : .none
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
